#!/usr/bin/env bash
# Instala Google Cloud CLI (gcloud) dentro del Codespace.
set -euo pipefail

chmod +x lab.sh scripts/*.sh 2>/dev/null || true

if command -v gcloud >/dev/null 2>&1; then
  echo "gcloud ya está instalado: $(gcloud --version | head -1)"
  exit 0
fi

echo ">> Instalando Google Cloud CLI..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg \
  | sudo gpg --dearmor --yes -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
  | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list >/dev/null
sudo apt-get update -y
sudo apt-get install -y google-cloud-cli

echo ">> Listo: $(gcloud --version | head -1)"
