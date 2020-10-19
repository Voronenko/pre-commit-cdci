#!/usr/bin/env bash
set -e

if ! command -v jq.node &> /dev/null
then
    echo "jq.node not found, run  npm i jq.node -g"
    exit
fi

if ! command -v curl &> /dev/null
then
    echo "curl not found, please install"
    exit
fi

DATA=$(jq.node -r js-yaml -x 'jsYaml.safeLoad | thru(x => (JSON.stringify({content: JSON.stringify(x)})))' < .gitlab-ci.yml)
RESPONSE=S(curl -s --header "Content-Type: application/json" https://gitlab.com/api/v4/ci/lint --data $DATA)

if echo "$RESPONSE" | grep 'invalid'; then
  echo ".gitlab-ci configuration is invalid"
  echo $RESPONSE | jq.node
  exit 1
fi

