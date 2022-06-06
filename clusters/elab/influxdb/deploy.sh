#!/usr/bin/env bash

# Add Helm repo
helm repo add influxdata https://helm.influxdata.com

# Refresh Helm repos
helm repo update

# Install InfluxDB chart
helm upgrade --install --values values.yaml --namespace banka-dev banka-dev-influx influxdata/influxdb2
