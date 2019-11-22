import os
from random import randint
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine

"""
This file loads the environment secrets into memory and also manages database connections
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


DB_HOST = 'postgres'
DB_PORT = 5432
JWT_SECRET = load_environment('JWT_SECRET', default='secrest')
DB_USER = load_environment('DB_USER')
DB_PASS = load_environment('DB_PASS')
engine = initialize_engine()
