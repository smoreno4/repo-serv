#!/bin/bash

echo "=========================="
echo "Fecha: $(date)"
echo "=========================="

# Reporte de Interfaces de Red
echo -e "\n===== Reporte de Interfaces de Red ====="
ip addr show | grep -E 'lo|eth|docker|br|veth|n4m' | awk '/inet/ {print $2, $NF}'

# Claves SSH autorizadas
echo -e "\n===== Claves SSH Autorizadas ====="
cat ~/.ssh/authorized_keys | awk '{print $3}' | tr -s ' ' '\n'

# Servicios en ejecución
echo -e "\n===== Servicios en Ejecución ====="
systemctl list-units --type=service --no-pager | awk '{if ($4 == "running") print "\033[32m" $1 "\033[0m"; else if ($4 == "exited") print "\033[31m" $1 "\033[0m"}'

# Contenedores Docker
echo -e "\n===== Contenedores Docker ====="
docker ps -a --format "{{.Image}} {{.Status}}" | awk '{if ($2 == "Up") print "\033[32m" $0 "\033[0m"; else print "\033[31m" $0 "\033[0m"}'

# Procesos en ejecución
echo -e "\n===== Procesos Activos ====="
ps aux | awk '{print $1,"----" $11}'

# Contenido de /etc/crontab
echo -e "\n===== Contenido de /etc/crontab ====="
grep -v -e '^#' -e '^ *$' -e 'anacron' -e '^MAILTO=' -e '^SHELL=' -e '^PATH=' /etc/crontab

# Listado de archivos en /root
echo -e "\n===== Contenido de /root ====="
ls -la /root | awk '{if ($1 ~ /^d/) print "\033[0;34m" $3"/" $9 "\033[0m"; else print "\033[0;32m" $3"/" $9 "\033[0m"}'

# Listado de archivos en /opt
echo -e "\n===== Contenido de /opt ====="
ls -la /opt | awk '{if ($1 ~ /^d/) print "\033[0;34m" $3"/" $9 "\033[0m"; else print "\033[0;32m" $3"/" $9 "\033[0m"}'

echo -e "\n===== Fin del Reporte ====="
