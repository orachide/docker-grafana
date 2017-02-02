FROM grafana/grafana

MAINTAINER Rachide Ouattara (orachide)

RUN apt-get update \
    && apt-get -y --no-install-recommends install curl jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true

COPY ./run_grafana.sh /run_grafana.sh

COPY ./configure_datasources.sh /configure_datasources.sh

RUN chmod +x /*.sh

ENTRYPOINT ["/run_grafana.sh",\
			"/configure_datasources.sh"\
			]

