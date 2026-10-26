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

docker build --target seeder -t devops-seeder .
docker build --target agent  -t devops-agent  .

docker run -d \
  --name "$DB_CONTAINER" \
  --network "$NETWORK" \
  --label "$LABEL" \
  -e POSTGRES_USER="$DB_USER" \
  -e POSTGRES_PASSWORD="$DB_PASS" \
  -e POSTGRES_DB="$DB_NAME" \
  postgres:latest

echo "Waiting for Postgres to be ready..."
until docker exec "$DB_CONTAINER" pg_isready -U "$DB_USER" -d "$DB_NAME"; do
  sleep 1
done

docker run --rm \
  --name "$SEEDER_CONTAINER" \
  --network "$NETWORK" \
  --label "$LABEL" \
  --mount type=bind,source="$(pwd)/Chinook.db",target=/app/Chinook.db,readonly \
  -e SQLITE_FILE=/app/Chinook.db \
  -e DATABASE_URL="postgres://${DB_USER}:${DB_PASS}@${DB_CONTAINER}:5432/${DB_NAME}" \
  devops-seeder