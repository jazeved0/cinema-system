FROM alpine:edge

# Set the working directory to /app
WORKDIR /app
COPY ./api/requirements.txt /app

# Copy the current directory contents into the container at /app
RUN apk update && apk add linux-headers python3-dev pcre-dev uwsgi-python
RUN apk add build-base musl-dev python3
RUN apk add --virtual build-deps gcc musl-dev postgresql-dev


# Install any needed packages specified in requirements.txt
RUN pip3 install --trusted-host pypi.python.org -r requirements.txt
RUN apk del build-base musl-dev python3-dev

COPY ./api/ /app/
#COPY ./lib /app/lib

EXPOSE 5000



# Run app.py when the container launches
CMD ["uwsgi", "--ini", "config_uwsgi.ini"]
