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

CONTENT="$(<.gitlab-ci.yml)"

RESPONSE=$(jq --null-input --arg yaml "$CONTENT" '.content=$yaml' \
| curl -s 'https://gitlab.com/api/v4/ci/lint?include_merged_yaml=false' \
--header "PRIVATE-TOKEN: ${PRIVATE_GITLAB_TOKEN}" \
--header 'Content-Type: application/json' \
--data @-)

if echo "$RESPONSE" | grep 'invalid'; then
  echo ".gitlab-ci configuration is invalid"
  echo $RESPONSE | jq
  exit 1
fi

if echo "$RESPONSE" | grep 'unauthorized'; then
  echo "Failed to validate, check private token environment variable PRIVATE_GITLAB_TOKEN"
  echo $RESPONSE | jq
fi
