from flask import Flask, redirect, request, g, jsonify
from flask_restful import reqparse
from flask_cors import CORS
from sqlalchemy.exc import SQLAlchemyError
import functools

from auth import JWT, authenticated, get_failed_auth_resp, hash_password, provision_jwt
from config import get_session
from models import TUserDerived, Company
from register import r_user, r_customer, r_manager, r_manager_customer

"""
Contains the core of the API logic, including RESTful endpoints and custom
decorator functions
"""


app = Flask(__name__)
cors = CORS(app)


def get_db():
    if 'db' not in g:
        g.db = get_session()
    return g.db


@app.teardown_appcontext
def teardown_db(exec):
    db = g.pop('db', None)
    if db is not None:
        db.close()


def with_db(fn):
    """
    Introduces a database object which has a session attribute that
    lazily obtains a connection to the database. Additionally, wraps database
    execution errors
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        # Create lazy session getter with database class wrapper
        class Database:
            def __init__(self):
                self._session = None

            @property
            def session(self):
                if self._session is None:
                    self._session = get_db()
                return self._session

        try:
            # Call the function with the parameters
            return fn(*args, database=Database(), **kwargs)
        except SQLAlchemyError as e:
            print(e)
            return "A database error ocurred. Check input parameters", 400

    return wrapped


def params(*param_list):
    """
    Wraps an app route with automatic parameter parsing and
    existence validation
    """

    def _decorate(fn):
        @functools.wraps(fn)
        def wrapped(*args, **kwargs):
            # Parse all parameters
            parser = reqparse.RequestParser()
            for param in param_list:
                if type(param) == str:
                    parser.add_argument(param)
                else:
                    name, param_type = param
                    if param_type == list:
                        parser.add_argument(name, action='append')
                    else:
                        parser.add_argument(name, type=param_type)

            param_values = parser.parse_args()

            # Validate that all parameters were given
            for param in param_list:
                name = param
                if type(param) != str:
                    name = param[0]

                if param_values.get(name) is None:
                    return "Malformed request", 400

            # Call the function with the parameters
            return fn(*args, **param_values, **kwargs)
        return wrapped
    return _decorate


# Uptime checker route
@app.route('/status', methods=['GET'])
def status():
    return "All systems operational", 204


@app.route('/login', methods=['POST'])
@params("username", "password")
@with_db
def login(username, password, database):
    user = database.session.query(TUserDerived).filter(
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


@app.route('/register/user', methods=['POST'])
@params("first_name", "last_name", "username", "password")
@with_db
def register_user(*args, **kwargs):
    return r_user(*args, **kwargs)


@app.route('/register/manager', methods=['POST'])
@params("first_name", "last_name", "username", "password", "company", "street_address", "city", "state", "zipcode")
@with_db
def register_manager(*args, **kwargs):
    return r_manager(*args, **kwargs)


@app.route('/register/manager-customer', methods=['POST'])
@params("first_name", "last_name", "username", "password", "company", "street_address", "city", "state", "zipcode", ("credit_cards", list))
@with_db
def register_manager_customer(*args, **kwargs):
    return r_manager_customer(*args, **kwargs)


@app.route('/register/customer', methods=['POST'])
@params("first_name", "last_name", "username", "password", ("credit_cards", list))
@with_db
def register_customer(*args, **kwargs):
    return r_customer(*args, **kwargs)


@app.route('/companies', methods=['GET'])
@with_db
def get_companies(database):
    companies = database.session.query(Company).all()
    names = [company.name for company in companies]
    return jsonify(names), 200


@app.route('/admin/users', methods=['GET'])
def get_users():
    return "not implemented", 400


@app.route('/admin/users/approve', methods=['POST'])
@params("username")
def approve(usernames):
    return "not implemented", 400


@app.route('/admin/users/decline', methods=['POST'])
@params("username")
def decline(usernames):
    return "not implemented", 400


@app.route('/admin/companies/create', methods=['POST'])
@params("username")
def create_theater():
    return "not implemented", 400


@app.route('/admin/companies/detail', methods=['GET'])
@params("theater")
def get_theater_details(usernames):
    return "not implemented", 400


def app_factory():
    return app


if __name__ == '__main__':
    app.run()
