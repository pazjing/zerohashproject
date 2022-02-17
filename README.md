# Nodejs APP experience

 A simple Nodejs webservice application is built as docker image stored in docker hub and packaged as a helm chart package publish in github page hosted in `gh-pages` branch of this repository.

 ### Nodejs web application
 A simple webservice build by Nodejs that returns a json object containing spot price data from coinbase 
-  `/<currency>` support: EUR, GBP, USD and JPY request to https://api.coinbase.com/v2/prices/spot?currency=<currency>
- `/health` endpoint that returns 200 if the application is running
- `/metrics` endpoint that return health metrics by using  [prometheus-api-metrics](https://www.npmjs.com/package/prometheus-api-metrics)
- Some extra endpoints to support different test scenario
- Web server is running on port 3000
- This web app can be build as a docker image with steps in `Dockerfile` 

### Dockerize support 
-  Implementation via Github workflow `docker-buil-test-push.yaml` 
-  Including build docker image , spin up a container and run test using `app_test.sh`
-  Docker image is pushed to dockerhub with name as  [pazjing/zerohashapp](https://hub.docker.com/repository/docker/pazjing/zerohashapp) 
-  Slack message is configured to send out when test executes and image push

### Helm chart support 
-  `charts/zerohash-chart`contains the source file of the chart package.
- The chart package is published on `gh-pages` branch of this repostory.
- `halmchart-release.yaml` contains the workflow to package the chart and publish to github page.

### How to use docker locally
``` 
git clone https://github.com/pazjing/zerohashproject.git
cd zerohashproject
docker build . -t pazjing/zerohashapp:0.1.0
docker run -p 8080:3000 -d pazjing/zerohashapp:0.1.0
curl http://localhost:8080/health
curl http://localhost:8080/EUR
```

### How to use halm chart with minikube
Refer to the [gh-pages/README.md](https://github.com/pazjing/zerohashproject/blob/gh-pages/README.md)

### How to deploy docker into AWS ECS
Refer to the [terraform/README.md](https://github.com/pazjing/zerohashproject/blob//main/terraform/README.md)

