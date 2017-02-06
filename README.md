[![license](https://img.shields.io/github/license/orachide/docker-grafana.svg?style=flat-square)](https://opensource.org/licenses/MIT)

[![Docker Automated buil](https://img.shields.io/docker/automated/orachide/grafana.svg?style=flat-square)](https://hub.docker.com/r/orachide/grafana/)
[![Docker Pulls](https://img.shields.io/docker/pulls/orachide/grafana.svg?style=flat-square)](https://hub.docker.com/r/orachide/grafana/)
[![Docker Stars](https://img.shields.io/docker/stars/orachide/grafana.svg?style=flat-square)](https://hub.docker.com/r/orachide/grafana/)

# Grafana Docker image

This project is based on grafana/grafana docker image and add the ability to define datasources from *json files.

## Running your Grafana container

Start your container with datasources defined in  to create on run.

```
docker run \
  -d \
  -p 3000:3000 \
  --name=grafana \
  -v /datasources /etc/grafana/datasources \
  orachide/grafana
```
Datasources *json files should be placed in your */datasources* in the above example.
All other features from grafana/grafana image still work 
