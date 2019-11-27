from flask import Flask, g, jsonify
from flask_restful import Api, Resource, reqparse
from flask_cors import CORS
from sqlachemy import and_

from auth import authenticated, get_failed_auth_resp
from auth import hash_password, provision_jwt

from config import get_session
from models import TUserDerived, Company, Visit
from register import r_user, r_customer, r_manager, r_manager_customer

"""
Contains the core of the API logic, including RESTful endpoints and custom
decorator functions
"""


app = Flask(__name__)
cors = CORS(app)


def parse_args(*param_list):
    parser = reqparse.RequestParser()
    for param in param_list:
        if type(param) == str:
            parser.add_argument(param, required=True)
        else:
            name, param_type = param
            if param_type == list:
                parser.add_argument(name, action='append', required=True)
            else:
                parser.add_argument(name, type=param_type, required=True)

    param_values = parser.parse_args()

    return (param_values[p] for p in param_list)


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
            return provision_jwt(user).get_token(), 200


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
                ("credit_cards", list)),
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
                ("credit_cards", list)),
            self.db
        )


class Companies(DBResource):
    def get(self):
        companies = self.db.query(Company).all()
        return jsonify([c.name for c in companies]), 200


class VisitResource(DBResource):
    @authenticated
    def get(self, jwt):
        company, start_date, end_date = parse_args("company", "start_date", "end_date")
        visits = self.db.query(Visit).filter(and_(
            Visit.username == jwt.username,
            Visit.companyname == company,
            Visit.date.between(start_date, end_date)
        )).all()
        return jsonify({"visits": visits or ()}), 200


# Uptime checker route
@app.route('/status', methods=['GET'])
def status():
    return "All systems operational", 204


def app_factory():
    api = Api(app)
    api.add_resource(Login, "/login")
    api.add_resource(Companies, "/companies")
    # api.add_resource(RegistrationUser, "/registration/user")
    api.add_resource(RegistrationUser, "/register/user")
    # api.add_resource(RegistrationManager, "/registration/manager")
    api.add_resource(RegistrationManager, "/register/manager")
    # api.add_resource(RegistrationCustomer, "/registration/customer")
    api.add_resource(RegistrationCustomer, "/register/customer")
    # api.add_resource(RegistrationManagerCustomer, "/registration/manager-customer")
    api.add_resource(RegistrationManagerCustomer, "/register/manager-customer")
    api.add_resource(VisitResource, "/visits")
    return app
