#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

readonly DATA_SOURCES_DIR="${DATA_SOURCES_DIR:-/etc/grafana/datasources}"
readonly GRAFANA_BASE_URL="${GRAFANA_BASE_URL:-http://localhost:3000}"
readonly GRAFANA_API_BASE_URL="${GRAFANA_API_BASE_URL:-http://admin:admin@localhost:3000}"
info() {
    local MESSAGE="${1}"

    echo "${MESSAGE}" >> bootstrap.log
}

fail() {
    local MESSAGE="${1}"
    local EXIT_CODE="${2:-1}"

    echo "${MESSAGE}" >> bootstrap.log
    exit "${EXIT_CODE}"
}

wait_for_url() {
    declare url="$1" max_retries="${2:-100}"
    for _ in $(seq 1 "${max_retries}"); do
        curl -XGET -s "${url}" > /dev/null \
            && return 0

        sleep 1
    done

    return 1  # fail if we didn't return earlier
}

add_data_sources() {
    if [ -d "$DATA_SOURCES_DIR" ]; then
	    _DATASOURCES=$(curl -XGET -fsS ${GRAFANA_API_BASE_URL}/api/datasources)
	    for data_source_file in ${DATA_SOURCES_DIR}/*.json; do
	        local _DATASOURCE_NAME=$(cat ${data_source_file} | jq -r '.name')
	        echo $_DATASOURCES | jq -r '.[].name' | grep -q $_DATASOURCE_NAME
	        if [ $? -gt 0 ]; then
		        info "Sending file ${data_source_file}"
	            curl -XPOST -fsS "${GRAFANA_API_BASE_URL}/api/datasources" \
	                -H 'Content-Type: application/json;charset=UTF-8' \
	                --data-binary "@${data_source_file}" \
	                > /dev/null
	            info "Datasource ${_DATASOURCE_NAME} added"
	        else
	            info "Datasource ${_DATASOURCE_NAME} skipped"
	        fi
	    done
	else
		info "No datasources directory defined"
    fi
}

main() {
    info "Waiting for Grafana..."
    if ! wait_for_url "${GRAFANA_BASE_URL}"; then
        fail "Failed to connect to Grafana at ${GRAFANA_BASE_URL}"
    fi

    info "Adding data sources..."

    if ! add_data_sources; then
        fail "Failed to add data sources..."
    fi

    info "Finished successfully"

    exec sleep infinity  # sleep to keep other processes in the container alive
}

main