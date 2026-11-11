#!/usr/bin/env bash
# Punto de entrada: ./lab.sh [configurar|login|bucket|vm|nginx|verificar|todo|limpiar]
set -euo pipefail
cd "$(dirname "$0")"
S=scripts

configurar() {
  echo "Completa con los datos del panel izquierdo del laboratorio:"
  read -r -p "  Project ID: " P
  read -r -p "  Zona (ej. us-east1-b): " Z
  read -r -p "  Nombre del bucket [$P]: " B
  B="${B:-$P}"
  cat > lab.env <<EOF
PROJECT_ID="$P"
ZONE="$Z"
BUCKET_NAME="$B"
INSTANCE_NAME="my-instance"
DISK_NAME="mydisk"
EOF
  echo "✔ Guardado en lab.env"
}

todo() {
  bash $S/01-bucket.sh
  bash $S/02-vm-disco.sh
  bash $S/03-nginx.sh
  bash $S/04-verificar.sh
}

menu() {
  cat <<'EOF'

  The Basics of Google Cloud Compute: Challenge Lab
  -------------------------------------------------
   1) Configurar datos del lab (lab.env)
   2) Iniciar sesión en Google Cloud
   3) Tarea 1 · Crear bucket
   4) Tarea 2 · Crear VM y adjuntar disco
   5) Tarea 3 · Instalar NGINX
   6) Verificar las 3 tareas
   7) Ejecutar tareas 1-3 + verificar
   8) Limpiar recursos (opcional)
   0) Salir
EOF
  read -r -p "  Opción: " O
  case "$O" in
    1) configurar ;; 2) bash $S/00-login.sh ;; 3) bash $S/01-bucket.sh ;;
    4) bash $S/02-vm-disco.sh ;; 5) bash $S/03-nginx.sh ;; 6) bash $S/04-verificar.sh ;;
    7) todo ;; 8) bash $S/99-limpiar.sh ;; 0) exit 0 ;; *) echo "Opción no válida" ;;
  esac
}

case "${1:-menu}" in
  configurar) configurar ;;
  login)      bash $S/00-login.sh ;;
  bucket)     bash $S/01-bucket.sh ;;
  vm)         bash $S/02-vm-disco.sh ;;
  nginx)      bash $S/03-nginx.sh ;;
  verificar)  bash $S/04-verificar.sh ;;
  todo)       todo ;;
  limpiar)    bash $S/99-limpiar.sh ;;
  menu)       menu ;;
  *) echo "Uso: ./lab.sh [configurar|login|bucket|vm|nginx|verificar|todo|limpiar]"; exit 1 ;;
esac
