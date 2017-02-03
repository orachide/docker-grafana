#!/bin/bash
chown -R grafana:grafana /etc/grafana
./run.sh&
exec /configure_datasources.sh