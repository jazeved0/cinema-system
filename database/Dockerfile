FROM postgres
WORKDIR /docker-entrypoint-initdb.d
COPY ./database/*.sql /docker-entrypoint-initdb.d/
ENV POSTGRES_USER=user
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_DB=Team20
EXPOSE 5432
