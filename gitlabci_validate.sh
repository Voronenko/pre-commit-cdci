#!/usr/bin/env bash
set -e

if ! command -v jq &> /dev/null
then
    echo "jq not found, please install in PATH"
    exit
fi

if ! command -v curl &> /dev/null
then
    echo "curl not found, please install"
    exit
fi

DATA=$(jq --null-input --arg yaml "$(<.gitlab-ci.yml)" '.content=$yaml')
RESPONSE=S(curl -s --header "Content-Type: application/json" https://gitlab.com/api/v4/ci/lint --data $DATA)

if echo "$RESPONSE" | grep 'invalid'; then
  echo ".gitlab-ci configuration is invalid"
  echo $RESPONSE | jq
  exit 1
fi

