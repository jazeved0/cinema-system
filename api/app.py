from flask import Flask, redirect, request, g
from flask_restful import Api, Resource, reqparse
from flask_cors import CORS
import requests
import json


app = Flask(__name__)
cors = CORS(app)


@app.route('/login', methods=['POST'])
def login():
    parser = reqparse.RequestParser()
    parser.add_argument('username')
    parser.add_argument('password')
    args = parser.parse_args()
    if args.get('username') is None or args.get('password') is None:
        return "Malformed request", 400

    return "This should be a jwt but I haven't implemented that yet", 200


@app.route('/register', methods=['POST'])
def register():
    return "not implemented", 400


if __name__ == '__main__':
    app.run()
