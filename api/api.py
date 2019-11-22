from flask import Flask, redirect, request, g
from flask_restful import Api, Resource, reqparse
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
def teardown_db():
    db = g.pop('db', None)
    if db is not None:
        db.close()


class CustomResource(Resource):
    """Default flask Resource but contains tools to talk to the shard nodes and the db"""
    def __init__(self):
        self._session = None
        self.topic = (getnode() << 15) | os.getpid()
        self.client = get_rpc_client(self.topic)

    @property
    def session(self):
        if self._session is None:
            self._session = get_db()
        return self._session

    def shard_call(self, method, *args, routing_guild=None, **kwargs):
        return self.client.call(
            method,
            *args,
            routing_key=f"shard_rpc_{which_shard(routing_guild)}",
            **kwargs
        )


def with_db(fn):
    """
    Introduces a get_session function which obtains a connection to the database
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        # Create lazy session getter with session closure
        session = None
        def get_session():
            nonlocal session
            if session is None:
                session = get_db()
            return session

        # Call the function with the parameters
        return fn(*args, get_session=get_session, **kwargs)


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
def test():
    a = get_session()
    print(a)
    
    return "not implemented", 400


@app.route('/login', methods=['POST'])
@params("username", "password")
@with_db
def login(username, password, get_session):
    a = get_session()
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
    api = Api(app)
    api.add_resource(User, "/user/<string:name>")
    api.add_resource(Settings, "/settings/<int:guild_id>/<string:setting>", "/settings/<int:guild_id>")
    api.add_resource(Identify, "/identify")
    api.add_resource(ListGuilds, "/guilds")
    api.add_resource(Stats, "/stats/<int:guild_id>/<string:stat>")
    api.add_resource(Login, "/login")
    return app
    
if __name__ == '__main__':
    app.run()
