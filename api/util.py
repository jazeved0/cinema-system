import re
from flask import jsonify

first_cap_re = re.compile('(.)([A-Z][a-z]+)')
all_cap_re = re.compile('([a-z0-9])([A-Z])')


def to_snake_case(camel_case: str) -> str:
    """
    Converts snake case string to camel case
    """

    first_pass = first_cap_re.sub(r'\1_\2', camel_case)
    return all_cap_re.sub(r'\1_\2', first_pass).lower()


def to_camel_case(snake_case: str) -> str:
    """
    Converts camel case string to snake case
    """

    if len(snake_case) == 0:
        return snake_case
    pascal = snake_case.title().replace("_", "")
    return pascal[0].lower() + pascal[1:]


def serialize(obj, table=None):
    """
    Takes a single or list of sqlalchemy objects and serializes to
    JSON-compatible base python objects before constructing a response.
    """

    return jsonify(to_dict(obj, table=table))


def to_dict(obj, table=None):
    """
    Takes a single or list of sqlalchemy objects and serializes to
    JSON-compatible base python objects.
    """

    data = None
    serialize_obj = serialize_object if table is None else (
        lambda o: serialize_result_row(o, table))
    if obj is not None:
        try:
            _ = iter(obj)
        except TypeError:
            # not iterable
            data = serialize_obj(obj)
        else:
            data = [serialize_obj(o) for o in obj]
    return data

def serialize_object(model) -> dict:
    """
    Takes an object and maps it into a dict using built-in
    """

    try:
        return model.as_dict()
    except AttributeError:
        return model


def serialize_result_row(row, table) -> dict:
    """
    Takes a sqlalchemy result object and maps it into a dict
    using column names
    """

    return dict((col, getattr(row, col)) for col in table.c.keys() if hasattr(row, col))
