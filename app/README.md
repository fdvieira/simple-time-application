# How to build and run the application
Here's described how to build the docker image and then run the service by using docker. 

```sh
cd app
docker build -t repository/image:tag .
docker run -d -p 8080:8080 repository/image:tag
```

Then access localhost:8080 and check the two endpoints:
- localhost:8080
- localhost:8080/health
