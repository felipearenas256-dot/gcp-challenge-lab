#!/usr/bin/env bash
# Instala Google Cloud CLI (gcloud) dentro del Codespace.
# Se descarga el paquete oficial de Google (sin apt), porque algunas imágenes
# de Codespaces traen repositorios apt con llaves vencidas que hacen fallar apt-get.
set -euo pipefail

chmod +x lab.sh scripts/*.sh 2>/dev/null || true

if command -v gcloud >/dev/null 2>&1; then
  echo "gcloud ya está instalado: $(gcloud --version | head -1)"
  exit 0
fi

DESTINO="$HOME/google-cloud-sdk"
URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz"

echo ">> Descargando Google Cloud CLI..."
curl -fsSL "$URL" -o /tmp/gcloud.tar.gz
tar -xzf /tmp/gcloud.tar.gz -C "$HOME"
rm -f /tmp/gcloud.tar.gz

"$DESTINO/install.sh" --quiet --usage-reporting=false --path-update=true --command-completion=true

# Enlaces en /usr/local/bin para que gcloud funcione en cualquier terminal.
for b in gcloud gsutil bq; do
  sudo ln -sf "$DESTINO/bin/$b" "/usr/local/bin/$b"
done

echo ">> Listo: $(gcloud --version | head -1)"
