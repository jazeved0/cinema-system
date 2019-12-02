# [![Cinema System](https://i.imgur.com/ENP1kJ7.png)](https://cinema-system.ga/)

[![API Uptime](https://img.shields.io/uptimerobot/ratio/7/m783881568-314a6d43a6abb50ec5c7a67f.svg?label=api%20uptime)](https://status.cinema-system.ga/) [![Netlify Status](https://api.netlify.com/api/v1/badges/f30033b8-a74c-427b-91d2-be5b2c46694d/deploy-status)](https://app.netlify.com/sites/cinema-system/deploys)

> Database application to manage and view movie viewings at theaters, created as the result of a semester-long group project for CS 4400: Intro to Database Systems with Professor Mark Moss. The application is composed of a PostgreSQL persistence layer, a Python Flask application layer, and a React-powered dashboard.

[![Web dashboard](https://i.imgur.com/7f0sbnn.png)](https://cinema-system.ga/app)

## 🚀 Getting Started

### 🐍 Backend Services

To run and develop the backend services locally, first make sure [Docker Compose is installed](https://docs.docker.com/compose/install/) and then run:

```
docker-compose up --build
```

to build the containers and run the application locally. The API will be accessible at `localhost:5000` and the database will be accessible at `localhost:5432`.

> **Note**: due to an issue in the way the `db` container/service is built, you may need to flush the locally built image any time the schema is changed. To do this, run the following commands in the project root:
> ```bash
> docker rm $(docker ps -a --format '{{.Names}}' | grep 'cs4400-team20' --color=never)
> docker rmi cs4400-team20_db
> docker-compose build db
> ```

### 🖥 Frontend App

To run and develop the frontend services locally, first ensure that both [Node.js](https://nodejs.org/en/download/) and a package manager of your choice (either [Yarn](https://yarnpkg.com/lang/en/) or [npm](https://www.npmjs.com/get-npm)) are installed. Then, simply run:

```
yarn install
```

to download the neccessary dependencies (make sure to run `npm install` if you are using npm).

#### 📡 Development Server

Because the web application is built with [create-react-app](https://create-react-app.dev/) at its core, there are two options to preview the app while developing: a **hot reload-enabled development server** *(recommended)* and a **minified app bundle**.

##### Hot-reload-enabled

```console
yarn start
```

##### Minified app bundle

```console
yarn build
yarn serve
```

### Code Style

Cinema System uses [eslint](https://eslint.org/) and [prettier](https://prettier.io/) to enforce JavaScript code style across the repository. To run the linter locally, run:

```console
yarn run lint
```

## 🛠 Tooling

- [Netlify](https://www.netlify.com/) - Used to automatically deploy & generate previews for PRs. Deploy information is available at [the Deploy page](https://app.netlify.com/sites/cinema-system/deploys)
- [ESLint](https://eslint.org/) / [Prettier](https://prettier.io/) - Used to enforce consistent code style across the project & catch errors
- [UptimeRobot](uptimerobot.com) - Used to track uptime and notify upon outage for [the website and the API](https://status.cinema-system.ga/)
