# [![Cinema System](https://i.imgur.com/msjskh5.png)](https://cinema-system.ga/)

[![Build Status](https://github.com/jazevedo620/cinema-system/workflows/Build%2FTest/badge.svg)](https://github.com/jazevedo620/cinema-system/actions) [![Dashboard Uptime](https://img.shields.io/uptimerobot/ratio/7/m783881574-ce7d7fc9be865ba1cbece837.svg?label=dashboard%20uptime)](https://status.cinema-system.ga/) [![API Uptime](https://img.shields.io/uptimerobot/ratio/7/m783881568-e1844c7ab23ce7316c87dbe5.svg?label=api%20uptime)](https://status.cinema-system.ga/) [![Contributors](https://img.shields.io/github/contributors/jazevedo620/cinema-system.svg)](https://github.com/jazevedo620/cinema-system/graphs/contributors) [![Netlify Status](https://img.shields.io/netlify/4b9228bb-9ea1-41bd-80b5-b1fad3e8ab94)](https://app.netlify.com/sites/cinema-system/deploys)

> Database application to manage and view movie viewings at theaters, created as the result of a semester-long group project for CS 4400: Intro to Database Systems with Professor Mark Moss. The application is composed of a PostgreSQL persistence layer, a Python Flask application layer, and a React-powered dashboard.

[![Web dashboard](https://i.imgur.com/EsPMPRS.png)](https://cinema-system.ga/app) 
## 🚀 Getting Started

### 🐍 Backend Services

To run and develop the backend services locally, first make sure [Docker Compose is installed](https://docs.docker.com/compose/install/) and then run:

```console
```

### 🖥 Frontend App

To run and develop the frontend services locally, first ensure that both [Node.js](https://nodejs.org/en/download/) and a package manager of your choice (either [Yarn](https://yarnpkg.com/lang/en/) or [npm](https://www.npmjs.com/get-npm)) are installed. Then, simply run:

```console
cd app
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

## 🛠 Tooling

- [Netlify](https://www.netlify.com/) - Used to automatically deploy & generate previews for branches and pull requests. Deploy status is available at [the Deploy page](https://app.netlify.com/sites/cinema-system/deploys)
- [ESLint](https://eslint.org/) / [Prettier](https://prettier.io/) - Used to enforce consistent code style across the frontend codebase & to catch errors
- [Flake8](http://flake8.pycqa.org/) - Used to enforce consistent code style across the backend codebase & to catch errors
- [UptimeRobot](https://uptimerobot.com/) - Used to track uptime and notify upon outage for [the website and the API](https://status.cinema-system.ga/)
- [DockerHub](https://hub.docker.com/) - Used to host both the [application layer image](https://hub.docker.com/repository/docker/jazevedo6/cinema-system-api) and the [persistence layer image](https://hub.docker.com/repository/docker/jazevedo6/cinema-system-db)
- [Github Actions](https://github.com/jazevedo6/cinema-system/actions) - Used to automatically build & lint both the front and back ends, as well as to push the backend containers to DockerHub

## 👥 Contributors

Our team for CS 4400 consisted of the following members:

- Joseph Azevedo ([jazevedo620](https://github.com/jazevedo620))
- Jonathan Buchanan ([johnyburd](https://github.com/johnyburd))
- Bhanu Garg ([unahb](https://github.com/unahb))
- Lucas Zhang ([LucasZhang58](https://github.com/LucasZhang58))
  
