# Backend Source

This directory contains the source code that both the application layer (`./api`) and persistence layer (`./database`) are based on.

## 🚀 Running

To get started, run:

```console
docker-compose up
```

Alternatively, to build using local source, run:

```console
docker-compose up --build
```

> **Note**: due to an issue in the way the `db` container/service is built, you may need to flush the locally built image any time the schema is changed. To do this, run the following commands in the project root:
>
> ```bash
> docker rm $(docker ps -a --format '{{.Names}}' | grep 'cinema-system')
> docker rmi cinema-system_db
> docker-compose build db
> ```

## 🎨Code Style

The backend uses [flake8](http://flake8.pycqa.org/) to enforce Python code style across the codebase. To install the linter to run locally, run:

```console
python3.7 -m pip install flake8
```

Then, to lint the codebase, run:

```console
cd api
python3.7 -m flake8 --show-source --statistics --show-source
```

## 🖥 Hosting

In the final project, the service is hosted using our own hardware, and is reconfigured to use WSGI as the outbound communication protocol from the application. Then, an Nginx proxy frontend is set up to act as the web server and provide both HTTP connectivity as well as SSL termination.
