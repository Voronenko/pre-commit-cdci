#!/usr/bin/env bash
set -e

if ! command -v circleci &> /dev/null
then
    echo "circleci binary not found, skipped"
    exit
fi

if ! eMSG=$(circleci config validate -c .circleci/config.yml --skip-update-check); then
	echo "CircleCI Configuration Failed Validation."
	echo $eMSG
	exit 1
fi
