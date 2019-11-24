FROM postgres
WORKDIR /docker-entrypoint-initdb.d
COPY ./database/*.sql /docker-entrypoint-initdb.d/
EXPOSE 5432
