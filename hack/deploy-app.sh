#!/usr/bin/env bash

set -euo pipefail

NAMESPACE=${NAMESPACE}

for f in ./app/*
do
  cat "$f" | sed "s/NAMESPACE/${NAMESPACE}/" | kubectl apply -f -
done
