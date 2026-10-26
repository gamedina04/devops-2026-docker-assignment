#!/bin/sh
set -eu

LABEL="com.example.devops2026"

docker ps -aq --filter "label=$LABEL" | xargs -r docker rm -f # Remove all containers created by project

docker volume ls -q --filter "label=$LABEL" | xargs -r docker volume rm -f # Remove volumes attached to the previous containers

docker network ls -q --filter "label=$LABEL" | xargs -r docker network rm -f # Removes the user-defined network