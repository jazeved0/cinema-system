import os
from random import randint
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine

"""
Loads the environment secrets into memory and manages database connections
"""


SENTINEL = object()
def load_environment(key, default=SENTINEL):
    """
    Loads an environment variable, and if not found, then defaults to the specified
    value (or raises an error if none was specified.)
    """

    value = os.getenv(key)
    if value is None:
        if default is not SENTINEL:
            print(f"{key} is not configured. Falling back to default value.")
            value = default
        else:
            raise EnvironmentError(
                f"A value for {key} cannot be found. See environemt configuration")
    return value


def initialize_engine():
    """
    Initializes the Postgres database engine to spawn sessions off of
    as needed later.
    """

    print("Initializing engine...")
    return create_engine(
        f"postgresql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/Team20")


def get_session():
    """
    Creates and returns a new database session
    """

    print("Creating a new db session")
    Session = sessionmaker(bind=engine)
    return Session()


JWT_SECRET = load_environment('JWT_SECRET', default='secret')
DB_USER = load_environment('DB_USER')
DB_PASS = load_environment('DB_PASSWORD')
DB_HOST = load_environment('DB_HOST')
DB_PORT = load_environment('DB_PORT')
LOGIN_URL = load_environment('LOGIN_URL', default='/login')
SALT_FORMAT = load_environment('SALT_FORMAT', default='#~{}')
engine = initialize_engine()

states = ["AL", "AK", "AS", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FM", "FL", "GA", "GU", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MH", "MD", "MA", "MI", "MN", "MS",
          "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "MP", "OH", "OK", "OR", "PW", "PA", "PR", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VI", "VA", "WA", "WV", "WI", "WY"]
