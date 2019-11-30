from flask import Flask, g, jsonify
from flask_restful import Api, inputs
from flask_cors import CORS
from sqlalchemy import and_
from sqlalchemy.exc import SQLAlchemyError
from datetime import datetime

from auth import authenticated, get_failed_auth_resp, hash_password, \
    provision_jwt, requires_admin, requires_manager
from config import states
from models import TUserDerived, Company, Visit, User, TCompanyDerived, \
    Theater, Manager, Movie
from register import registration
from util import to_dict, remove_non_numeric, DBResource, parse_args, Param

"""
Contains the core of the API logic, including RESTful endpoints and custom
decorator functions
"""


app = Flask(__name__)
cors = CORS(app)


@app.teardown_appcontext
def teardown_db(exec):
    db = g.pop('db', None)
    if db is not None:
        db.close()


class Login(DBResource):
    def post(self):
        username, password = parse_args("username", "password")

        user = self.db.query(TUserDerived).filter(
            TUserDerived.c.username == username).first()

        if user is None:
            return get_failed_auth_resp(message="Incorrect username or password")

        # Perform password hash equality check
        password_hash = hash_password(password, user)
        if user.password != password_hash:
            return get_failed_auth_resp(message="Incorrect username or password")
        else:
            print("Successful authentication: {}".format(user.username))
            token = provision_jwt(user).get_token().decode()
            return jsonify({"token": token})


class Companies(DBResource):
    def get(self):
        only_names, = parse_args(Param("only_names", optional=True, type=inputs.boolean))
        if only_names:
            companies = self.db.query(Company.name).all()
            return jsonify({"companies": [c.name for c in companies]})
        else:
            return self.get_all_auth()

    @authenticated
    @requires_admin
    def get_all_auth(self):
        companies = self.db.query(TCompanyDerived).all()
        return jsonify({"companies": to_dict(companies, table=TCompanyDerived)})


class CompaniesTheaters(DBResource):
    @authenticated
    @requires_admin
    def get(self, name):
        theaters = self.db.query(Theater).filter(
            Theater.companyname == name
        )
        return jsonify({"theaters": to_dict(theaters)})


class CompaniesManagers(DBResource):
    @authenticated
    @requires_admin
    def get(self, name):
        managers = self.db.query(Manager).filter(
            Manager.companyname == name
        )
        # Remove hashed password from output
        return jsonify({"managers": to_dict(managers, scrub=["password"])})


class CompaniesNumTheaters(DBResource):
    def get(self, company):
        num = self.db.query(Theater).filter(Theater.companyname == company.replace("%20", " ")).count()
        return jsonify({"num_theaters": num})


class CompaniesNumEmployees(DBResource):
    def get(self, company):
        num = self.db.query(Manager).filter(Manager.companyname == company).count()
        return jsonify({"num_employees": num})


class CompaniesNumCities(DBResource):
    def get(self, company):
        num = self.db.query(Theater).distinct(Theater.city).filter(
            Theater.companyname == company.replace("%20", " ")).count()
        return jsonify({"num_cities": num})


class Users(DBResource):
    @authenticated
    @requires_admin
    def get(self):
        users = self.db.query(TUserDerived).all()
        # Remove hashed passwords from API output
        return jsonify({"users": to_dict(users, table=TUserDerived, scrub=["password"])})


class UserApproveResource(DBResource):
    @authenticated
    @requires_admin
    def put(self, username):
        user = self.db.query(User).filter(User.username == username).first()
        if not user:
            return f"Cannot find user {username}", 404

        if user.status == "Approved":
            # Not changed
            return "Cannot approve already approved user", 304

        try:
            self.db.query(User).filter(User.username == username).update(
                {"status": "Approved"})
        except SQLAlchemyError:
            # Forbidden
            return "Could not approve user", 403
        else:
            self.db.commit()
            return "Success", 200


class UserDeclineResource(DBResource):
    @authenticated
    @requires_admin
    def put(self, username):
        user = self.db.query(User).filter(User.username == username).first()
        if not user:
            return f"Cannot find user {username}", 404

        if user.status == "Approved":
            # Bad request
            return "Cannot decline already approved user", 400
        elif user.status == "Declined":
            # Not changed
            return "Cannot decline already declined user", 304

        try:
            self.db.query(User).filter(User.username == username).update(
                {"status": "Approved"})
        except SQLAlchemyError:
            # Forbidden
            return "Could not decline user", 403
        else:
            self.db.commit()
            return "Success", 200


class EligibleManagers(DBResource):
    @authenticated
    @requires_admin
    def get(self):
        try:
            managers = self.db.query(Manager).outerjoin(Theater).filter(
                Theater.theatername == None).all()
        except SQLAlchemyError:
            return "Could not find eligible managers", 403
        else:
            return jsonify({"managers": to_dict(managers, fields=[
                "username", "companyname", "firstname", "lastname"])})


class Theaters(DBResource):
    @authenticated
    @requires_admin
    def post(self):
        theatername, companyname, state, city, zipcode, capacity, manager, street = parse_args(
            "theatername",
            "companyname",
            "state",
            "city",
            "zipcode",
            "capacity",
            "manager",
            "street"
        )

        # Validate that company is valid
        company = self.db.query(Company).filter(Company.name == companyname).first()
        if not company:
            return f"Company name {companyname} does not exist", 400

        # Validate that name is unique within company
        theater = self.db.query(Theater).filter(
            Theater.theatername == theatername, Theater.companyname == companyname).first()
        if theater:
            return f"Theater name {theatername} must be unique", 400

        # Validate that zipcode is in the correct format
        formatted_zipcode = remove_non_numeric(zipcode)
        if len(formatted_zipcode) != 5 or formatted_zipcode != zipcode:
            return f"Zipcode {formatted_zipcode} must be 5 digits long", 400

        # Validate state
        if state.upper() not in states:
            return "State must be a valid two-letter state", 400

        # Validate capacity
        if not capacity.isdigit() or int(capacity) <= 0:
            return "Capacity must be an integer greater than 1", 400

        # Validate that manager exists
        manager_object = self.db.query(Manager).filter(Manager.username == manager).first()
        if not manager_object:
            return f"Manager @{manager} does not exist", 400

        # Validate valid manager-company pairing
        if manager_object.companyname != companyname:
            return f"Manager @{manager} does not work for company {companyname}", 400

        # Validate that manager is not managing any other theaters
        manager_object = self.db.query(Manager).outerjoin(Theater).filter(
            Theater.theatername != None, Manager.username == manager).first()
        if manager_object:
            return f"Manager @{manager} is already managing a theater", 400

        try:
            theater = Theater(
                theatername=theatername,
                companyname=companyname,
                state=state,
                city=city,
                zipcode=zipcode,
                capacity=capacity,
                manager=manager,
                street=street
            )
            self.db.add(theater)
            self.db.commit()
        except SQLAlchemyError:
            return "Could not create theater", 403
        else:
            return 201


class Movies(DBResource):
    @authenticated
    @requires_admin
    def post(self):
        name, duration, releasedate = parse_args("name", "duration", "releasedate")

        # Validate that date is valid
        try:
            date = datetime.strptime(releasedate, "%Y-%m-%d")
        except ValueError:
            return "Duration must be a date in the format YYYY-MM-DD", 400

        # Validate that name/release date is unique
        movie = self.db.query(Movie).filter(
            Movie.name == name, Movie.releasedate == date).first()
        if movie:
            return f"Movie name and release date must be unique", 400

        # Validate that duration is valid
        if not duration.isdigit():
            return "Duration must be an integer", 400

        try:
            # Add to database
            movie = Movie(name=name, duration=duration, releasedate=date)
            self.db.add(movie)
            self.db.commit()
        except SQLAlchemyError:
            return "Could not create movie", 403
        else:
            return 201

    def get(self):
        movies = self.db.query(Movie).all()
        return jsonify({'movies': to_dict(movies)})


class MoviesSchedule(DBResource):
    @authenticated
    @requires_manager
    def post(self, jwt):
        moviename, releasedate, playdate = parse_args("moviename", "releasedate", "playdate")
        result = self.db.execute(
            "INSERT INTO movieplay (Date, MovieName, ReleaseDate, TheaterName, CompanyName) "
            "VALUES (:playdate, :moviename, :releasedate, ("
            "  SELECT TheaterName FROM Theater WHERE Manager = :username), ("
            "  SELECT CompanyName FROM Theater WHERE Manager = :username));",
            {"playdate": playdate, "moviename": moviename, "releasedate": releasedate, "username": jwt.username}
        )
        self.db.commit()
        return 204


class ExploreMovie(DBResource):
    def get(self):
        result = self.db.execute("select * from movieplay natural join theater").fetchall()
        return jsonify({'movies': [dict(row) for row in result]})


class TheaterOverview(DBResource):
    @authenticated
    @requires_manager
    def get(self, jwt):
        result = self.db.execute(
            "SELECT movie.Name AS movName, movie.Duration as movDuration,"
            "    movie.ReleaseDate AS movReleaseDate, t1.Date as movPlayDate "
            "FROM ("
            "  SELECT movieplay.*"
            "  FROM movieplay"
            "  LEFT JOIN theater ON movieplay.TheaterName = theater.TheaterName"
            "    AND movieplay.CompanyName = theater.CompanyName"
            "  WHERE :username = theater.Manager"
            ") AS t1 "
            "RIGHT JOIN movie ON t1.MovieName = movie.Name",
            {"username": jwt.username}
        ).fetchall()
        return jsonify({'movies': to_dict(result)})


class Visits(DBResource):
    @authenticated
    def get(self, jwt):
        company, start_date, end_date = parse_args("company", "startdate", "enddate")
        visits = self.db.query(Visit).filter(and_(
            Visit.username == jwt.username,
            Visit.companyname == company,
            Visit.date.between(start_date, end_date)
        )).all()
        return jsonify({'visits': to_dict(visits)})


# Uptime checker route
@app.route('/status', methods=['GET'])
def status():
    return "All systems operational", 204


def app_factory():
    api = Api(app)
    api.add_resource(Login, "/login")
    app.register_blueprint(registration, url_prefix="/register")
    api.add_resource(Visits, "/visits")
    api.add_resource(EligibleManagers, "/managers/eligible")

    api.add_resource(Companies, "/companies")
    api.add_resource(CompaniesManagers, "/companies/<string:name>/managers")
    api.add_resource(CompaniesTheaters, "/companies/<string:name>/theaters")

    api.add_resource(Movies, "/movies")
    api.add_resource(MoviesSchedule, "/movies/schedule")
    api.add_resource(ExploreMovie, "/movies/explore")

    api.add_resource(Theaters, "/theaters")
    api.add_resource(TheaterOverview, "/manager/overview")

    api.add_resource(Users, "/users")
    api.add_resource(UserApproveResource, "/users/<username>/approve")
    api.add_resource(UserDeclineResource, "/users/<username>/decline")

    return app
