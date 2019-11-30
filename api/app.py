from api import app_factory

"""
Bootstraps the main application
"""


application = app_factory()
if __name__ == '__main__':
    application.run(host='0.0.0.0')
