from flask import Flask, redirect, request, g
from flask_restful import reqparse
from flask_cors import CORS
import functools
import requests
import json
from auth import JWT, authenticated
from config import get_session

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
                parser.add_argument(param)
            param_values = parser.parse_args()

            # Validate that all parameters were given
            for param in param_list:
                if param_values.get(param) is None:
                    return "Malformed request", 400

            # Call the function with the parameters
            fn(*args, **param_values, **kwargs)
        return wrapped
    return _decorate


@app.route('/', methods=['GET'])
@with_db
def test(database):
    print(database.session)
    
    return "not implemented", 400


@app.route('/login', methods=['POST'])
@params("username", "password")
@with_db
def login(username, password, database):
    a = database.session
    print(a)

    return "not implemented", 400


@app.route('/register/user', methods=['POST'])
@params("first_name", "last_name", "username", "password")
def register_user(first_name, last_name, username, password):
    return "not implemented", 400


@app.route('/register/manager', methods=['POST'])
@params("first_name", "last_name", "username", "password", "company", "street_address", "city", "state", "zipcode")
def register_manager(first_name, last_name, username, password, company, street_address, city, state, zipcode):
    return "not implemented", 400


@app.route('/register/manager-customer', methods=['POST'])
@params("first_name", "last_name", "username", "password", "company", "street_address", "city", "state", "zipcode", "credit_cards")
def register_manager_customer(first_name, last_name, username, password, company, street_address, city, state, zipcode, credit_cards):
    return "not implemented", 400


@app.route('/register/customer', methods=['POST'])
@params("first_name", "last_name", "username", "password", "credit_cards")
def register_customer(first_name, last_name, username, password, credit_cards):
    return "not implemented", 400


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
