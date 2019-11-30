import re
from flask_restful import reqparse
from flask import jsonify, g
from typing import Dict, List, Union
from flask_restful import Resource

from config import get_session

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


def serialize(obj, table=None, scrub=None, fields=None):
    """
    Takes a single or list of sqlalchemy objects and serializes to
    JSON-compatible base python objects before constructing a response.
    """

    return jsonify(to_dict(obj, table=table, scrub=scrub))


def to_dict(obj, table=None, scrub=None, fields=None):
    """
    Takes a single or list of sqlalchemy objects and serializes to
    JSON-compatible base python objects. If scrub is set to True, then
    this function will also remove all keys that match the specified list
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
            if scrub:
                data = scrub_dict(data, scrub)
            if fields is not None:
                data = filter_dict(data, fields)
        else:
            data = [serialize_obj(o) for o in obj]
            if scrub:
                data = [scrub_dict(d, scrub) for d in data]
            if fields is not None:
                data = [filter_dict(d, fields) for d in data]

    return data


def scrub_dict(source: Dict, scrub: List[str]) -> Dict:
    """
    Removes the specified keys form the source dict
    """

    try:
        return {k: v for k, v in source.items() if k not in scrub}
    except AttributeError:
        return source


def filter_dict(source: Dict, fields: List[str]) -> Dict:
    """
    Only includes the specified keys from the source dict
    """

    try:
        return {k: v for k, v in source.items() if k in fields}
    except AttributeError:
        return source


def serialize_object(model) -> Dict:
    """
    Takes an object and maps it into a dict using built-in
    """

    try:
        return model.as_dict()
    except AttributeError:
        return model


def serialize_result_row(row, table) -> Dict:
    """
    Takes a sqlalchemy result object and maps it into a dict
    using column names
    """

    return dict((col, getattr(row, col)) for col in table.c.keys() if hasattr(row, col))


def remove_non_numeric(string: str) -> str:
    """
    Removes all non-numeric characters in the input string
    """

    return re.sub('[^0-9]', '', string)


class DBResource(Resource):
    """
    Represents a flask-restful resource that is also connected to the database
    """

    @property
    def db(self):
        if 'db' not in g:
            g.db = get_session()
        return g.db


class Param(object):
    """
    Represents a parameter named tuple with optional arguments for use
    in parse_args
    """

    def __init__(self, name: str, type=None, optional: bool = False):
        self.name = name
        self.type = type
        self.optional = optional


def parse_args(*param_list: List[Union[str, Param]], as_dict: bool = False):
    """
    Parses args via RequestParser
    """

    parser = reqparse.RequestParser()
    for param in param_list:
        if type(param) == str:
            parser.add_argument(param, required=True)
        else:
            required = not param.optional
            if param.type == list:
                parser.add_argument(param.name, action='append', required=required)
            else:
                parser.add_argument(param.name, type=param.type, required=required)

    param_values = parser.parse_args()
    param_names = [p if type(p) == str else p.name for p in param_list]

    if as_dict:
        return {p: param_values[p] for p in param_names}
    return (param_values[p] for p in param_names)
