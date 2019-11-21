from flask import Flask, redirect, request, g
from flask_restful import Api, Resource, reqparse
from flask_cors import CORS
import functools
import requests
import json
from .auth import JWT, authenticated


app = Flask(__name__)
cors = CORS(app)


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


@app.route('/login', methods=['POST'])
@params("username", "password")
def login(username, password):
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


if __name__ == '__main__':
    app.run()
