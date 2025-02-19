#!/bin/bash

# Fecha y hora de ejecución
echo "=========================="
echo "Fecha: $(date)"
echo "=========================="

echo -e "\n===== Reporte de Interfaces de Red ====="
ip addr show | grep -E 'lo|eth|docker|br|veth|n4m' | awk '/inet/ {print $2, $NF}'

echo -e "\n===== Claves SSH Autorizadas ====="
cat ~/.ssh/authorized_keys

echo -e "\n===== Servicios en Ejecución ====="
systemctl list-units --type=service --state=running

echo -e "\n===== Contenedores Docker ====="
docker ps -a

echo -e "\n===== Procesos en Ejecución ====="
ps aux

echo -e "\n===== Contenido de /etc/crontab ====="
cat /etc/crontab

echo -e "\n===== FIN DEL REPORTE ====="
