#!/bin/sh

set -eu

# Config
NETWORK=ai-agent-net
DB_NAME=chinook
DB_USER=chinook_user
DB_PASS=chinook_verysecretpassword
DB_CONTAINER=db
SEEDER_CONTAINER=seeder
GATEWAY_CONTAINER=gateway
AGENT_CONTAINER=agent
LABEL="com.example.devops2026" # Allows me to clean up later through the label

docker network create --label "$LABEL" "$NETWORK"