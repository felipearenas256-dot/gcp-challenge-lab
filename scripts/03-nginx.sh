#!/usr/bin/env bash
# TAREA 3: Instalar el servidor web NGINX en my-instance.
# Camino principal: SSH desde el Codespace con gcloud compute ssh.
# Respaldo: si SSH falla, se instala con un startup-script y se reinicia la VM.
source "$(dirname "$0")/comun.sh"
cargar_config
requiere_gcloud

titulo "Tarea 3 · Instalar NGINX"

INSTALAR='sudo apt-get update -y && sudo apt-get install -y nginx && sudo systemctl enable --now nginx && systemctl is-active nginx'

paso "Conectando por SSH a $INSTANCE_NAME e instalando NGINX"
if gcloud compute ssh "$INSTANCE_NAME" \
     --project="$PROJECT_ID" --zone="$ZONE" --quiet \
     --command="$INSTALAR"; then
  ok "NGINX instalado por SSH."
else
  error "SSH no funcionó (firewall o llaves). Usando el método de respaldo: startup-script."
  gcloud compute instances add-metadata "$INSTANCE_NAME" \
    --project="$PROJECT_ID" --zone="$ZONE" \
    --metadata=startup-script='#! /bin/bash
apt-get update -y
apt-get install -y nginx
systemctl enable --now nginx'
  gcloud compute instances reset "$INSTANCE_NAME" --project="$PROJECT_ID" --zone="$ZONE"
  ok "VM reiniciada; NGINX se instala al arrancar (1-2 minutos)."
fi

IP=$(gcloud compute instances describe "$INSTANCE_NAME" --project="$PROJECT_ID" --zone="$ZONE" \
      --format="value(networkInterfaces[0].accessConfigs[0].natIP)")

paso "Esperando respuesta HTTP en http://$IP ..."
for i in $(seq 1 30); do
  if curl -s --max-time 5 "http://$IP" | grep -qi "nginx"; then
    ok "NGINX responde en http://$IP"
    exit 0
  fi
  sleep 10
done
error "NGINX aún no responde en http://$IP. Espera un poco y ejecuta ./lab.sh verificar"
exit 1
