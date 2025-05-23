#!/bin/bash
echo "Running script with shell: $0"

set -e

# ====== Config Defaults ======
ENV="dev"
ORG="LocalDev"
OU_SERVER="DevDatabase"
OU_CLIENT="DevApp"

CERT_DIR="./certs"
ROOT_KEY="$CERT_DIR/root.key"
ROOT_CRT="$CERT_DIR/root.crt"
ROOT_SRL="$CERT_DIR/root.srl"

TARGETS=("postgres") # default target
declare -A CN_MAP
declare -A SAN_MAP

# ====== Argument Parsing ======
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --env=*) ENV="${1#*=}" ;;
    --env) ENV="$2"; shift ;;
    --targets=*) IFS=',' read -r -a TARGETS <<< "${1#*=}" ;;
    --targets) IFS=',' read -r -a TARGETS <<< "$2"; shift ;;
    *) echo "❌ Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

# ====== Prod-specific tweaks ======
if [[ "$ENV" == "prod" ]]; then
  ORG="MyApp"
  OU_SERVER="ProdDatabase"
  OU_CLIENT="ProdApp"
fi

# ====== CN and SAN definitions per target ======
for target in "${TARGETS[@]}"; do
  CN_MAP[$target]="$target"
  if [[ "$ENV" == "dev" ]]; then
    SAN_MAP[$target]="DNS:$target,DNS:localhost,IP:127.0.0.1"
  else
    SAN_MAP[$target]="DNS:$target,IP:127.0.0.1"
  fi
done

# ====== Root CA Generation ======
mkdir -p "$CERT_DIR"

if [[ ! -f $ROOT_KEY || ! -f $ROOT_CRT ]]; then
  echo "🔐 Generating Root CA..."
  openssl genrsa -out "$ROOT_KEY" 4096
  openssl req -x509 -new -nodes -key "$ROOT_KEY" -sha256 -days 3650 -out "$ROOT_CRT" \
    -subj "/C=NA/ST=None/L=None/O=$ORG/OU=Root/CN=RootCA"
else
  echo "✅ Root CA already exists"
fi

# ====== Server Cert Generator ======
generate_server_cert() {
  ENGINE=$1
  CN=${CN_MAP[$ENGINE]}
  SAN=${SAN_MAP[$ENGINE]}
  ENGINE_DIR="$CERT_DIR/$ENGINE"

  mkdir -p "$ENGINE_DIR"

  echo "🔐 Generating server cert for $ENGINE..."
  openssl genrsa -out "$ENGINE_DIR/server.key" 4096
  openssl req -new -key "$ENGINE_DIR/server.key" -out "$ENGINE_DIR/server.csr" \
    -subj "/C=NA/ST=None/L=None/O=$ORG/OU=$OU_SERVER/CN=$CN"

  openssl x509 -req -in "$ENGINE_DIR/server.csr" -CA "$ROOT_CRT" -CAkey "$ROOT_KEY" -CAcreateserial \
    -out "$ENGINE_DIR/server.crt" -days 3650 -sha256 \
    -extfile <(printf "subjectAltName=$SAN")

  rm "$ENGINE_DIR/server.csr"
}

# ====== Generate Certs for All Targets ======
for target in "${TARGETS[@]}"; do
  generate_server_cert "$target"
done

# ====== Client Cert ======
CLIENT_DIR="$CERT_DIR/client"
mkdir -p "$CLIENT_DIR"

if [[ ! -f $CLIENT_DIR/client.key || ! -f $CLIENT_DIR/client.crt ]]; then
  echo "🔐 Generating client certificate for CN=postgres..."
  openssl genrsa -out "$CLIENT_DIR/client.key" 4096
  openssl req -new -key "$CLIENT_DIR/client.key" -out "$CLIENT_DIR/client.csr" \
    -subj "/C=NA/ST=None/L=None/O=$ORG/OU=$OU_CLIENT/CN=postgres"

  openssl x509 -req -in "$CLIENT_DIR/client.csr" -CA "$ROOT_CRT" -CAkey "$ROOT_KEY" -CAcreateserial \
    -out "$CLIENT_DIR/client.crt" -days 3650 -sha256

  rm "$CLIENT_DIR/client.csr"
else
  echo "✅ Client cert already exists"
fi

echo "✅ All certs generated in $CERT_DIR"