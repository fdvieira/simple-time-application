# pulling the python image
FROM python:3.7.16-slim-bullseye

# set user homedir
ENV APP_HOME=/app

# set userUID
ARG APP_USER_UID=60031

# switch working directory
WORKDIR /app

# copy the application dependencies into the image
COPY . /app

# install the dependencies and packages in the requirements file
RUN pip3 install -r requirements.txt

# create application user 
RUN groupadd -r appuser -g ${APP_USER_UID} && useradd -d ${APP_HOME} --shell /bin/false -g appuser -u ${APP_USER_UID} appuser

# run the application with a different user than root
USER appuser

# configure the container to run in an executed manner
ENTRYPOINT ["python3"]

CMD ["app.py"]
