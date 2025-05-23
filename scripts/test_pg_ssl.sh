#!/usr/bin/env bash
set -euo pipefail

# === CONFIG ===
PG_HOST="postgres"               # Docker service or container name
PG_PORT="5432"
PG_DB="${POSTGRES_DB:-postgres}"
PG_USER="${POSTGRES_USER:-postgres}"
PG_PASS="${POSTGRES_PASSWORD:-password}"

CERTS_DIR="./certs"
ROOT_CERT="/certs/root.crt"
CLIENT_CERT="/certs/client/client.crt"
CLIENT_KEY="/certs/client/client.key"

# === RUN ===
echo "🔐 Testing Postgres SSL connection with mTLS..."

docker run -it --rm \
  --network container:postgres \
  -e PGPASSWORD="$PG_PASS" \
  -v "$(pwd)/certs:/certs:ro" \
  postgres:latest \
  psql \
    "sslmode=verify-full \
    host=$PG_HOST \
    port=$PG_PORT \
    dbname=$PG_DB \
    user=$PG_USER \
    sslrootcert=$ROOT_CERT \
    sslcert=$CLIENT_CERT \
    sslkey=$CLIENT_KEY"