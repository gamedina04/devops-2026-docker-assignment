#!/bin/sh
set -eu

LABEL="com.example.devops2026"

docker ps -aq --filter "label=$LABEL" | xargs -r docker rm -f # Remove all containers created by project