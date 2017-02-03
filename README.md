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
  grafana/grafana
```
Datasources *json files should be placed in your */datasources* in the above example.
All other features from grafana/grafana image still work 