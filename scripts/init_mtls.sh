#!/bin/bash

set -euo pipefail

CERT_DIR="/var/lib/postgresql/certs"
CERT_KEY="$CERT_DIR/server.key"
PG_HBA_CONF="$PGDATA/pg_hba.conf"

echo "🔧 Fixing permissions for Postgres server key"
chown postgres:postgres "$CERT_KEY"
chmod 600 "$CERT_KEY"

echo "🔐 Appending mTLS enforcement to pg_hba.conf"
echo "hostssl all all 0.0.0.0/0 cert clientcert=verify-full" >> "$PG_HBA_CONF"

echo "✅ SSL + mTLS setup completed"