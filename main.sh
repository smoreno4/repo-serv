#!/bin/bash

# Mostrar fecha y título
echo -e "=========================="
echo -e "Fecha: $(date)"
echo -e "=========================="
echo -e ""

# Reporte de Interfaces de Red
echo -e "===== Reporte de Interfaces de Red ====="
echo -e ""
ip -br addr show | grep -E 'lo|eth|docker|br|veth|n4m' | while read line; do
    # Filtrar y mostrar interfaces con IP
    if echo "$line" | grep -q 'inet'; then
        interface=$(echo "$line" | awk '{print $1}')
        ip_address=$(echo "$line" | awk '{print $3}')
        echo -e "$interface"
        echo -e "IP: $ip_address"
        echo -e ""
    fi
done

# Reporte de Cron Jobs
echo -e "===== Reporte de Cron Jobs ====="
echo -e ""

# Mostrar Cron Jobs del usuario root
echo -e "Cron Jobs del usuario root:"
crontab -l -u root 2>/dev/null || echo -e "No se encontraron Cron Jobs para el usuario root."
echo -e ""

# Mostrar archivos en cron.d
echo -e "Archivos en /etc/cron.d:"
ls /etc/cron.d/ 2>/dev/null || echo -e "No se encontraron archivos en /etc/cron.d."
echo -e ""

# Mostrar archivos en cron.daily
echo -e "Archivos en /etc/cron.daily:"
ls /etc/cron.daily/ 2>/dev/null || echo -e "No se encontraron archivos en /etc/cron.daily."
echo -e ""

# Mostrar archivos en cron.hourly
echo -e "Archivos en /etc/cron.hourly:"
ls /etc/cron.hourly/ 2>/dev/null || echo -e "No se encontraron archivos en /etc/cron.hourly."
echo -e ""

# Mostrar archivos en cron.monthly
echo -e "Archivos en /etc/cron.monthly:"
ls /etc/cron.monthly/ 2>/dev/null || echo -e "No se encontraron archivos en /etc/cron.monthly."
echo -e ""

# Mostrar archivos en cron.weekly
echo -e "Archivos en /etc/cron.weekly:"
ls /etc/cron.weekly/ 2>/dev/null || echo -e "No se encontraron archivos en /etc/cron.weekly."
echo -e ""

# Mostrar el contenido de /etc/crontab
echo -e "Contenido de /etc/crontab:"
cat /etc/crontab
