import jwt as pyjwt
import os
import functools
import base64
from flask import request, Response
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

from config import JWT_SECRET, LOGIN_URL, SALT_FORMAT

"""
Handles JWT-based authentication & provdes a validation route decorator
Also handles password hashing code
"""


def hash_password(user, password):
    """
    Hashes the given password using the user's username to generate a salt
    """

    if user is None or user.username is None:
        return ""

    username = user.username
    salt = SALT_FORMAT.format(username)
    salted_password = password + salt
    digest = hashes.Hash(hashes.SHA256(), backend=default_backend())
    digest.update(salted_password.encode())
    hashed_bytes = digest.finalize()
    return base64.b64encode(hashed_bytes).decode()


def provision_jwt(user):
    """"
    Provisions a new JWT for the given user upon successful authentication
    """

    payload = {
        'first_name': user.firstname,
        'last_name': user.lastname,
        'is_admin': user.isadmin,
        'is_manager': user.ismanager,
        'is_customer': user.iscustomer,
        'status': user.status,
        'cc_count': user.creditcardcount
    }

    return JWT(data=payload)


def get_failed_auth_resp(message="Not Authorized"):
    """
    Returns a failed authentication 401 response, including the
    'WWW-Authenticate' response header as per the 401 response specifications
    """

    resp = Response(message, 401)
    resp.headers['WWW-Authenticate'] = LOGIN_URL
    return resp


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
            return get_failed_auth_resp()

        return fn(*args, jwt=jwt, **kwargs)
    return wrapped


class JWT:
    """
    Represents a single JWT that exists decoded by default, but can be
    encoded at any time
    """

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
