import jwt as pyjwt
import functools
import base64
from flask import request, Response
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

from util import to_snake_case, to_camel_case
from config import JWT_SECRET, LOGIN_URL, SALT_FORMAT

"""
Handles JWT-based authentication & provdes a validation route decorator
Also handles password hashing code
"""


def hash_password(password, user):
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


def provision_jwt(user, is_admin=None, is_manager=None, is_customer=None,
                  cc_count=None):
    """"
    Provisions a new JWT for the given user upon successful authentication
    """

    # Whether to use named arguments to define authorization/cc
    flag = (is_admin is not None
            or is_manager is not None
            or is_customer is not None
            or cc_count is not None)
    is_admin = is_admin or False if flag else user.isadmin
    is_manager = is_manager or False if flag else user.ismanager
    is_customer = is_customer or False if flag else user.iscustomer
    cc_count = cc_count if flag else user.creditcardcount

    payload = {
        'first_name': user.firstname,
        'last_name': user.lastname,
        'is_admin': is_admin,
        'is_manager': is_manager,
        'is_customer': is_customer,
        'status': user.status,
        'cc_count': cc_count,
        'username': user.username
    }

    return JWT(data=payload)


def get_failed_auth_resp(message="Requires authentication"):
    """
    Returns a failed authentication 401 response, including the
    'WWW-Authenticate' response header as per the 401 response
    specifications
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
        if 'Authorization' not in request.headers:
            return get_failed_auth_resp()

        try:
            jwt = JWT(token=request.headers['Authorization'])
        except pyjwt.exceptions.InvalidTokenError:
            return get_failed_auth_resp("Invalid token supplied")

        return fn(*args, jwt=jwt, **kwargs)
    return wrapped


def requires_admin(fn):
    """
    Validates that the authenticated user is an admin
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        if 'jwt' in kwargs:
            jwt = kwargs.pop("jwt")
            if not jwt.is_admin:
                return get_failed_auth_resp(
                    "Insufficient authorization: requires admin status")

            # If passed, continue with route
            return fn(*args, **kwargs)

        else:
            return "requires_admin needs JWT", 500
    return wrapped


def requires_manager(fn):
    """
    Validates that the authenticated user is a manager
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        if 'jwt' in kwargs:
            jwt = kwargs["jwt"]
            if not jwt.is_manager:
                return get_failed_auth_resp(
                    "Insufficient authorization: requires manager status")

            # If passed, continue with route
            return fn(*args, **kwargs)

        else:
            return "requires_manager needs JWT", 500
    return wrapped


def requires_customer(fn):
    """
    Validates that the authenticated user is a customer
    """

    @functools.wraps(fn)
    def wrapped(*args, **kwargs):
        if 'jwt' in kwargs:
            jwt = kwargs["jwt"]
            if not jwt.is_customer:
                return get_failed_auth_resp(
                    "Insufficient authorization: requires customer status")

            # If passed, continue with route
            return fn(*args, **kwargs)

        else:
            return "requires_customer needs JWT", 500
    return wrapped


class JWT:
    """
    Represents a single JWT that exists decoded by default, but can be
    encoded at any time
    """

    def __init__(self, data=None, token=None):
        assert data is not None or token is not None

        if data is None:
            decoded = self._decode(token)
            self._data = {to_snake_case(key): value for key, value
                          in decoded.items()}
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
        return pyjwt.encode({to_camel_case(key): value for key, value
                             in payload.items()}, JWT_SECRET, algorithm='HS256')
