#!/bin/bash

echo "=========================="
echo "Fecha: $(date)"
echo "=========================="

# Reporte de Sistema
echo -e "\n===== Reporte de Disco Duro ====="
df -h | awk '{if ($1 ~ /^\/dev/) { 
    usage = substr($5, 1, length($5)-1); 
    if (usage > 85) 
        print "\033[31m" $1, $2, $4, $5 "\033[0m"; 
    else 
        print "\033[32m" $1, $2, $4, $5 "\033[0m"; 
}}'

# Reporte de Cpu y Ram
echo -e "\n===== Reporte de CPU y RAM ====="
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'); if [ $(echo "$cpu_usage > 85" | awk '{if ($1 > 85) print 1; else print 0}') -eq 1 ]; then echo -e "CPU=\033[31m$cpu_usage%\033[0m"; else echo -e "CPU=\033[32m$cpu_usage%\033[0m"; fi; free -m | awk '/Mem/ {usage=$3/$2*100; if (usage > 85) print "RAM=\033[31m" $3 "MB/" $2 "MB (" int(usage) "%)\033[0m"; else print "RAM=\033[32m" $3 "MB/" $2 "MB (" int(usage) "%)\033[0m"}'

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
ps aux | awk '{print $1,"----" $11}' | sort | uniq

# Contenido de /etc/crontab
echo -e "\n===== Cron Jobs de Usuario =====" && for user in $(cut -f1 -d: /etc/passwd); do crontab -u $user -l &>/dev/null && echo -e "Tareas programadas de $user:" && crontab -u $user -l || echo "No hay tareas programadas para $user"; done && echo -e "\n===== Cron Jobs Globales (en /etc/crontab) =====" && grep -v -e '^#' -e '^ *$' -e 'anacron' -e '^MAILTO=' -e '^SHELL=' -e '^PATH=' /etc/crontab

# Listado de archivos en /root
echo -e "\n===== Contenido de /root ====="
ls -la /root | awk '{if ($1 ~ /^d/) print "\033[0;34m" $3"/" $9 "\033[0m"; else print "\033[0;32m" $3"/" $9 "\033[0m"}'

# Listado de archivos en /opt
echo -e "\n===== Contenido de /opt ====="
ls -la /opt | awk '{if ($1 ~ /^d/) print "\033[0;34m" $3"/" $9 "\033[0m"; else print "\033[0;32m" $3"/" $9 "\033[0m"}'

# Listado de archivos en servicios
echo -e "\n===== Contenido de puertos y users ====="
ss -tulnp | awk '{print $5, $7}' | grep -oP '([0-9\.\:\*]+:[0-9]+|:::?[0-9]+)\s+users:.*' | sed 's/(pid=[0-9]*,fd=[0-9]*)//g' | sed 's/users://g' | sed 's/"//g' | sed 's/(//g' | sed 's/,.*)//g' | awk -F '[ :)]+' '{print $1 ":" $2, $3}' | sed 's/^[*:]*://' | awk '{print "\033[34m" $1 "\033[0m | \033[32m" $2 "\033[0m"}'

# Listado de archivos en iptables
echo -e "\n===== Contenido de iptables ====="


echo -e "\n===== Fin del Reporte ====="
