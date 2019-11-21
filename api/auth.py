import jwt as pyjwt
import os
import functools
from flask import request


JWT_SECRET = os.getenv('JWT_SECRET')
if JWT_SECRET is None:
    print("A JWT secret is not configured. Falling back to default value.")
    JWT_SECRET = "secret"


def authenticated(fn):
    """
    Wraps an app route for authentication headers.
    Returns 401 if user is not logged in.
    Adds a JWT object to the kwargs for id data
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        try:
            jwt = JWT(token=request.headers['Authorization'])
        except pyjwt.exceptions.InvalidTokenError:
            return "Not Authorized", 401

        return fn(*args, jwt=jwt, **kwargs)
    return wrapped


class JWT:
    def __init__(self, data=None, token=None):
        assert data is not None or token is not None

        if data is None:
            self._data = self._decode(token)
        else:
            self._data = data

        self._token = token
        self._dirty = token is None

    def get_token(self):
        if self._dirty:
            self._token = self._encode(self._data)
            self._dirty = False
        return self._token

    def __getattr__(self, name):
        try:
            return self._data[name]
        except KeyError:
            raise AttributeError(f"no such attribute {name}") from None

    def _decode(self, token):
        return pyjwt.decode(token, JWT_SECRET, algorithm='HS256')

    def _encode(self, payload):
        return pyjwt.encode(payload, JWT_SECRET, algorithm='HS256')
