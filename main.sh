#!/bin/bash

# Script para verificar exporters comunes y mostrar URLs oficiales de descarga

echo "=== Diagnóstico de exporters comunes en $(hostname -f) ==="
echo ""

declare -A exporters
declare -A exporters_urls

# Exporters y procesos a detectar
exporters=(
  ["node_exporter"]="node_exporter"
  ["systemd_exporter"]="systemd_exporter"
  ["mongodb_exporter"]="mongodb_exporter"
  ["blackbox_exporter"]="blackbox_exporter"
  ["cadvisor"]="cadvisor"
  ["nginx_exporter"]="nginx_exporter"
  ["postgres_exporter"]="postgres_exporter"
)

# URLs oficiales para descarga
exporters_urls=(
  ["node_exporter"]="https://github.com/prometheus/node_exporter/releases/latest/download/node_exporter-*-linux-amd64.tar.gz"
  ["systemd_exporter"]="https://github.com/prometheus-community/systemd_exporter/releases/latest/download/systemd_exporter.tar.gz"
  ["mongodb_exporter"]="https://github.com/percona/mongodb_exporter/releases/download/v0.47.1/mongodb_exporter-0.47.1.linux-64-bit.deb"
  ["blackbox_exporter"]="https://github.com/prometheus/blackbox_exporter/releases/latest/download/blackbox_exporter-*-linux-amd64.tar.gz"
  ["cadvisor"]="https://github.com/google/cadvisor/releases/latest/download/cadvisor"
  ["nginx_exporter"]="https://github.com/nginxinc/nginx-prometheus-exporter/releases/latest/download/nginx-prometheus-exporter_linux_amd64"
  ["postgres_exporter"]="https://github.com/prometheus-community/postgres_exporter/releases/latest/download/postgres_exporter-*-linux-amd64.tar.gz"
)

for exp in "${!exporters[@]}"; do
  echo "- $exp:"
  nr=$(pgrep -f "${exporters[$exp]}" > /dev/null; echo $?)
  if [[ $nr -eq 0 ]]; then
    ports=$(ss -tulnp 2>/dev/null | grep "${exporters[$exp]}" | awk '{print $5}' | sed -E 's/.*:([0-9]+)/\1/' | sort -u | tr '\n' ', ' | sed 's/, $//')
    echo "  RUNNING - Puertos: ${ports:-no encontrado}"
  else
    echo "  NOT RUNNING"
  fi
  echo "  Oficial URL: ${exporters_urls[$exp]}"
  echo ""
done

echo "=== Resumen ==="
for exp in "${!exporters[@]}"; do
  nr=$(pgrep -f "${exporters[$exp]}" > /dev/null; echo $?)
  printf "%-17s : %s\n" "$exp" "$( [[ $nr -eq 0 ]] && echo 'ON' || echo 'OFF' )"
done

# Fin del script
