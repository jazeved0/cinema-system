import functools

from auth import hash_password, provision_jwt
from models import TUserDerived, User, Company, Manager, Customer, Creditcard
from config import states

"""
Handles registration validation & database mutation for the 4 registration
endpoints
"""


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
        kwargs["credit_cards"] = trimmed_cc
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
            Manager).filter(Manager.state == kwargs.get("state"), Manager.city == kwargs.get("city"), Manager.zipcode == kwargs.get("zipcode"), Manager.street == kwargs.get("street")).first()
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


@validate_user
def r_user(first_name, last_name, username, password, database):
    # Add new user to the database
    new_user = User(username=username, password=None,
                    firstname=first_name, lastname=last_name)
    new_user.password = hash_password(password, new_user)
    database.session.add(new_user)
    database.session.commit()
    return provision_jwt(new_user, cc_count=0).get_token(), 200


@validate_user
@validate_manager
def r_manager(first_name, last_name, username, password, company, street_address, city, state, zipcode, database):
    # Add new manager to the database
    new_manager = Manager(username=username, password=None, firstname=first_name, lastname=last_name,
                          state=state, city=city, zipcode=zipcode, street=street_address, companyname=company)
    new_manager.password = hash_password(password, new_manager)
    database.session.add(new_manager)
    database.session.commit()
    return provision_jwt(new_manager, is_manager=True, cc_count=0).get_token(), 200


@validate_user
@validate_customer
@validate_manager
def r_manager_customer(first_name, last_name, username, password, company, street_address, city, state, zipcode, credit_cards, database):
    # Generate Manager row
    new_manager = Manager(username=username, password=None, firstname=first_name, lastname=last_name,
                          state=state, city=city, zipcode=zipcode, street=street_address, companyname=company)
    new_manager.password = hash_password(password, new_manager)
    database.session.add(new_manager)
    database.session.commit()

    # Execute an insert onto Customer manually to avoid duplicate User creation
    database.session.execute(Customer.__table__.insert(), {
                             "username": username, "password": new_manager.password, "firstname": first_name, "lastname": last_name})

    # Insert credit cards
    new_credit_cards = [Creditcard(
        creditcardnum=cc, owner=username) for cc in credit_cards]
    database.session.add_all(new_credit_cards)
    database.session.commit()
    return provision_jwt(new_manager, is_manager=True, is_customer=True, cc_count=len(credit_cards)).get_token(), 200


@validate_user
@validate_customer
def r_customer(first_name, last_name, username, password, credit_cards, database):
    # Add new customer to the database
    new_customer = Customer(username=username, password=None,
                            firstname=first_name, lastname=last_name)
    new_customer.password = hash_password(password, new_customer)

    new_credit_cards = [Creditcard(
        creditcardnum=cc, owner=username) for cc in credit_cards]

    database.session.add_all([new_customer] + new_credit_cards)
    database.session.commit()
    return provision_jwt(new_customer, is_customer=True, cc_count=len(credit_cards)).get_token(), 200
