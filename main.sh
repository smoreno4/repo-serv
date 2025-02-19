#!/bin/bash

echo "=========================="
echo "Fecha: $(date)"
echo "=========================="

# Reporte de Interfaces de Red
echo -e "\n===== Reporte de Interfaces de Red ====="
ip addr show | grep -E 'lo|eth|docker|br|veth|n4m' | awk '/inet/ {print $2, $NF}'

# Claves SSH autorizadas
echo -e "\n===== Claves SSH Autorizadas ====="
cat ~/.ssh/authorized_keys

# Servicios en ejecución
echo -e "\n===== Servicios en Ejecución ====="
systemctl list-units --type=service --state=running

# Contenedores Docker
echo -e "\n===== Contenedores Docker ====="
docker ps -a

# Procesos en ejecución
echo -e "\n===== Procesos Activos ====="
ps aux

# Contenido de /etc/crontab
echo -e "\n===== Contenido de /etc/crontab ====="
cat /etc/crontab

# Listado de archivos en /root
echo -e "\n===== Contenido de /root ====="
ls -la /root

# Listado de archivos en /opt
echo -e "\n===== Contenido de /opt ====="
ls -la /opt

echo -e "\n===== Fin del Reporte ====="
