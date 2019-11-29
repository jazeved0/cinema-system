from flask import Flask, g, jsonify, make_response
from flask_restful import Api, Resource, reqparse, inputs
from flask_cors import CORS
from sqlalchemy import and_
from sqlalchemy.exc import SQLAlchemyError

from auth import authenticated, get_failed_auth_resp, hash_password, \
    provision_jwt, requires_admin
from config import get_session
from models import TUserDerived, Company, Visit, User, TCompanyDerived, \
    Theater, Manager
from register import r_user, r_customer, r_manager, r_manager_customer
from util import serialize, to_dict

"""
Contains the core of the API logic, including RESTful endpoints and custom
decorator functions
"""


app = Flask(__name__)
cors = CORS(app)


class Param(object):
    def __init__(self, name, type=None, optional=False):
        self.name = name
        self.type = type
        self.optional = optional


def parse_args(*param_list):
    parser = reqparse.RequestParser()
    for param in param_list:
        if type(param) == str:
            parser.add_argument(param, required=True)
        else:
            required = not param.optional
            if param.type == list:
                parser.add_argument(param.name, action='append', required=required)
            else:
                parser.add_argument(param.name, type=param.type, required=required)

    param_values = parser.parse_args()
    param_names = [p if type(p) == str else p.name for p in param_list]
    return (param_values[p] for p in param_names)


@app.teardown_appcontext
def teardown_db(exec):
    db = g.pop('db', None)
    if db is not None:
        db.close()


class DBResource(Resource):
    @property
    def db(self):
        if 'db' not in g:
            g.db = get_session()
        return g.db


class ListResource(Resource):
    @staticmethod
    def register(api, resource_class, route, param="id"):
        api.add_resource(resource_class, route, f"{route}/<{param}>",
                         resource_class_kwargs={"id_name": param})

    def __init__(self, *args, **kwargs):
        id_name = kwargs.pop("id_name")
        self.id_name = id_name
        super().__init__(*args, **kwargs)

    def get(self, *args, **kwargs):
        if self.id_name in kwargs:
            id_param = kwargs.pop(self.id_name)
            return self.get_by_id(id_param, *args, **kwargs)
        else:
            return self.get_all(*args, **kwargs)

    def get_all(self):
        pass

    def get_by_id(self, id):
        pass


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
            return token, 200


class RegistrationUser(DBResource):
    def post(self):
        return r_user(*parse_args("first_name", "last_name", "username", "password"), self.db)


class RegistrationManager(DBResource):
    def post(self):
        return r_manager(
            *parse_args(
                "first_name",
                "last_name",
                "username",
                "password",
                "company",
                "street_address",
                "city",
                "state",
                "zipcode"),
            self.db
        )


class RegistrationCustomer(DBResource):
    def post(self):
        return r_customer(
            *parse_args(
                "first_name",
                "last_name",
                "username",
                "password",
                Param("credit_cards", type=list)),
            self.db
        )


class RegistrationManagerCustomer(DBResource):
    def post(self):
        return r_manager_customer(
            *parse_args(
                "first_name",
                "last_name",
                "username",
                "password",
                "company",
                "street_address",
                "city",
                "state",
                "zipcode",
                Param("credit_cards", type=list)),
            self.db
        )


class Companies(DBResource, ListResource):
    def get_all(self):
        only_names, = parse_args(Param("only_names", optional=True, type=inputs.boolean))
        if only_names:
            companies = self.db.query(Company.name).all()
            return serialize([c.name for c in companies])
        else:
            return self.get_all_auth()

    @authenticated
    @requires_admin
    def get_all_auth(self):
        companies = self.db.query(TCompanyDerived).all()
        return serialize(companies, table=TCompanyDerived)

    @authenticated
    @requires_admin
    def get_by_id(self, name):
        company = self.db.query(TCompanyDerived).filter(
            TCompanyDerived.c.name == name).first()
        return serialize(company, table=TCompanyDerived)


class CompaniesNumTheaters(DBResource):
    def get(self, company):
        num = self.db.query(Theater).filter(Theater.companyname == company.replace("%20", " ")).count()
        return make_response(jsonify({"num_theaters": num}), 200)


class CompaniesNumEmployees(DBResource):
    def get(self, company):
        num = self.db.query(Manager).filter(Manager.companyname == company.replace("&20", " ")).count()
        return make_response(jsonify({"num_employees": num}), 200)


class CompaniesNumCities(DBResource):
    def get(self, company):
        num = self.db.query(Theater).distinct(Theater.city).filter(
            Theater.companyname == company.replace("%20", " ")).count()
        return make_response(jsonify({"num_cities": num}), 200)


class Users(DBResource):
    @authenticated
    @requires_admin
    def get(self):
        users = self.db.query(TUserDerived).all()
        # Remove hashed passwords from API output
        scrubbed = [{k: v for k, v in user.items() if k != "password"}
                    for user in to_dict(users, table=TUserDerived)]
        return jsonify(scrubbed)


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


class CompaniesNumTheaters(DBResource):
    def get(self, company):
        num = self.db.query(Theater).filter(Theater.companyname == company.replace("+", " ")).count()
        return make_response(jsonify({"num_theaters": num}), 200)


class CompaniesNumEmployees(DBResource):
    def get(self, company):
        num = self.db.query(Manager).filter(Manager.companyname == company.replace("+", " ")).count()
        return make_response(jsonify({"num_employees": num}), 200)


class CompaniesNumCities(DBResource):
    def get(self, company):
        num = self.db.query(Theater).distinct(Theater.city).filter(
            Theater.companyname == company.replace("+", " ")).count()
        return make_response(jsonify({"num_cities": num}), 200)


class Theaters(DBResource):
    def post(self):
        # TODO validation
        tn, cn, state, city, zip, cap, man, st = parse_args(
            "theatername",
            "companyname",
            "state",
            "city",
            "zipcode",
            "capacity",
            "manager",
            "street"
        )

        theater = Theater(
            theatername=tn,
            companyname=cn,
            state=state,
            city=city,
            zipcode=zip,
            capacity=cap,
            manager=man,
            street=st
        )
        self.db.add(theater)
        self.db.commit()

        return 204


class Visits(DBResource):
    @authenticated
    def get(self, jwt):
        company, start_date, end_date = parse_args("company", "start_date", "end_date")
        visits = self.db.query(Visit).filter(and_(
            Visit.username == jwt.username,
            Visit.companyname == company,
            Visit.date.between(start_date, end_date)
        )).all()
        return serialize(visits)


# Uptime checker route
@app.route('/status', methods=['GET'])
def status():
    return "All systems operational", 204


def app_factory():
    api = Api(app)
    api.add_resource(Login, "/login")
    ListResource.register(api, Companies, "/companies", param="name")
    api.add_resource(Users, "/users")
    api.add_resource(UserApproveResource, "/users/<username>/approve")
    api.add_resource(UserDeclineResource, "/users/<username>/decline")
    api.add_resource(CompaniesNumEmployees, "/companies/<string:company>/num_employees")
    api.add_resource(CompaniesNumCities, "/companies/<string:company>/num_cities")
    api.add_resource(CompaniesNumTheaters, "/companies/<string:company>/num_theaters")
    api.add_resource(RegistrationUser, "/register/user")
    api.add_resource(RegistrationManager, "/register/manager")
    api.add_resource(RegistrationCustomer, "/register/customer")
    api.add_resource(RegistrationManagerCustomer, "/register/manager-customer")
    api.add_resource(Theaters, "/theaters")
    api.add_resource(Visits, "/visits")
    return app
