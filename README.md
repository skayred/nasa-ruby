# GraphQL API for NASA asteroids data

This is the backend part for the NASA test assignment, frontend part can be found [there](https://github.com/skayred/nasa-vue)
In order to get the project running, you need to pull both projects and build their Docker images:

```
cd nasa-vue
sh build.sh
cd ../nasa-ruby
sh build.sh
```

## Running details

You can use Docker Compose to run all the components - UI, Backend, and PostgreSQL database. To start the installation, please run the command like below:

```
cd nasa-ruby
DBPASSWORD=CHANGE_ME NASA_API_KEY=YOUR_KEY docker-compose up -d
```

*NB* running the project requires you to apply for the NASA API key first!

This command will first run the UI and DB, then wait for the DB startup, and then run the backend. Backend will run the migrations.

## UI access

When the Docker Compose is ready, you can access the UI through your [localhost:8080](https://localhost:8080)
