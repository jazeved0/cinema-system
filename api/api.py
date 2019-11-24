from flask import Flask, redirect, request, g
from flask_restful import reqparse
from flask_cors import CORS
import functools
import requests
import json

from auth import JWT, authenticated, get_failed_auth_resp, hash_password, provision_jwt
from config import get_session, states
from models import TUserDerived, User, Company, Manager, Customer, Creditcard

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
    lazily obtains a connection to the database
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

        # Call the function with the parameters
        return fn(*args, database=Database(), **kwargs)
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


def validate_user(fn):
    """
    Validates that usernames are unique and passwords are >= 8 chars long
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        # Validate password length
        if len(kwargs.get("password")) < 8:
            return "Password must be at least 8 characters long", 400

        # Validate unique username
        dup_user = kwargs.get("database").session.query(TUserDerived).filter(
            TUserDerived.c.username == kwargs.get("username")).first()
        if dup_user is not None:
            return "Username must be unique", 400

        # If passed, continue with registration
        return fn(*args, **kwargs)
    return wrapped


def validate_customer(fn):
    """
    Validates that credit cards are between 1 and 5 and that each is 16 chars long
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        # Validate credit card length
        cc_list = kwargs.get("credit_cards")
        trimmed_cc = [cc.replace(' ', '') for cc in cc_list]
        num_credit_cards = len(trimmed_cc)
        if num_credit_cards < 1 or num_credit_cards > 5:
            return "Number of credit cards must be between 1 and 5, inclusive", 400

        # Validate credit card composition
        for cc in trimmed_cc:
            if len(cc) != 16 or not cc.isdigit():
                return f"Credit card {cc} must be 16 digits long", 400

        # If passed, continue with registration
        kwargs.setdefault("credit_cards", trimmed_cc)
        return fn(*args, **kwargs)
    return wrapped


def validate_manager(fn):
    """
    Validates that manager addresses are unique and are formatted correctly.
    Also makes sure the company is valid
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        # Validate state
        if kwargs.get("state").upper() not in states:
            return "State must be a valid two-letter state", 400

        # Validate address uniqueness
        manager_dup = kwargs.get("database").session.query(
            Manager).filter(Manager.state == kwargs.get("state") and Manager.city == kwargs.get("city") and Manager.zipcode == kwargs.get("zipcode") and Manager.street == kwargs.get("street")).first()
        if manager_dup is not None:
            return "Address must be unique", 400

        # Validate company
        company = kwargs.get("database").session.query(Company).filter(
            Company.name == kwargs.get("company")).first()
        if company is None:
            return "Company must be an existing company in the system", 400

        # If passed, continue with registration
        return fn(*args, **kwargs)
    return wrapped


def create_user(username, password, first_name, last_name):
    new_user = User(username=username, password=None,
                    firstname=first_name, lastname=last_name, status="Pending")
    new_user.password = hash_password(password, new_user)
    return new_user


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
@validate_user
def register_user(first_name, last_name, username, password, database):
    # Add new user to the database
    new_user = create_user(username, password, first_name, last_name)
    database.session.add(new_user)
    database.session.commit()
    return provision_jwt(new_user, cc_count=0).get_token(), 200


@app.route('/register/manager', methods=['POST'])
@params("first_name", "last_name", "username", "password", "company", "street_address", "city", "state", "zipcode")
@with_db
@validate_user
@validate_manager
def register_manager(first_name, last_name, username, password, company, street_address, city, state, zipcode, database):
    # Generate User row
    new_user = create_user(username, password, first_name, last_name)

    # Generate Manager row
    new_manager = Manager(username=username, state=state, city=city,
                          zipcode=zipcode, street=street_address, companyname=company)

    database.session.add(new_user)
    database.session.add(new_manager)
    database.session.commit()
    return provision_jwt(new_user, is_manager=True, cc_count=0).get_token(), 200


@app.route('/register/manager-customer', methods=['POST'])
@params("first_name", "last_name", "username", "password", "company", "street_address", "city", "state", "zipcode", ("credit_cards", list))
@with_db
@validate_user
@validate_customer
@validate_manager
def register_manager_customer(first_name, last_name, username, password, company, street_address, city, state, zipcode, credit_cards, database):
    # Generate User row
    new_user = create_user(username, password, first_name, last_name)

    # Generate Manager row
    new_manager = Manager(username=username, state=state, city=city,
                          zipcode=zipcode, street=street_address, companyname=company)

    # Generate Customer row
    new_customer = Customer(username=username)
    new_credit_cards = [Creditcard(creditcardnum=cc, owner=username) for cc in credit_cards]

    database.session.add(new_user)
    database.session.add(new_customer)
    database.session.add(new_manager)
    database.session.add_all(new_credit_cards)
    database.session.commit()
    return provision_jwt(new_user, is_manager=True, is_customer=True, cc_count=len(credit_cards)).get_token(), 200


@app.route('/register/customer', methods=['POST'])
@params("first_name", "last_name", "username", "password", ("credit_cards", list))
@with_db
@validate_user
@validate_customer
def register_customer(first_name, last_name, username, password, credit_cards, database):
    # Generate User row
    new_user = create_user(username, password, first_name, last_name)

    # Generate Customer row
    new_customer = Customer(new_user)
    new_credit_cards = [Creditcard(
        creditcardnum=cc, owner=username) for cc in credit_cards]

    database.session.add(new_user)
    database.session.commit()
    database.session.add(new_customer)
    database.session.commit()
    database.session.add_all(new_credit_cards)
    database.session.commit()
    return provision_jwt(new_user, is_customer=True, cc_count=len(credit_cards)).get_token(), 200


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


@app.route('/admin/companies', methods=['GET'])
def get_companies():
    return "not implemented", 400


@app.route('/admin/companies/create', methods=['POST'])
@params("username")
def create_theather():
    return "not implemented", 400


@app.route('/admin/companies/detail', methods=['GET'])
@params("theather")
def get_theater_details(usernames):
    return "not implemented", 400


def app_factory():
    return app


if __name__ == '__main__':
    app.run()
