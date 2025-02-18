#!/bin/bash

# Función para poner texto en color
color_echo() {
    case $1 in
        "green")
            echo -e "\033[32m$2\033[0m"
            ;;
        "yellow")
            echo -e "\033[33m$2\033[0m"
            ;;
        "red")
            echo -e "\033[31m$2\033[0m"
            ;;
        "blue")
            echo -e "\033[34m$2\033[0m"
            ;;
        *)
            echo -e "$2"
            ;;
    esac
}

# Mostrar fecha y título
color_echo "blue" "=========================="
color_echo "blue" "Fecha: $(date)"
color_echo "blue" "=========================="
echo ""

# Reporte de Interfaces de Red
color_echo "green" "===== Reporte de Interfaces de Red ====="
echo ""

# Mostrar interfaces de red con IP
ip addr show | grep -E 'lo|eth|docker|br|veth|n4m' | awk '/inet/ {print $2, $NF}' | while read line; do
    interface=$(echo "$line" | awk '{print $2}')
    ip_address=$(echo "$line" | awk '{print $1}')
    color_echo "yellow" "$interface"
    color_echo "green" "IP: $ip_address"
    echo ""
done

# Reporte de Cron Jobs
color_echo "green" "===== Reporte de Cron Jobs ====="
echo ""

# Mostrar el contenido de /etc/crontab, eliminando comentarios y líneas innecesarias
color_echo "yellow" "Contenido de /etc/crontab:"
grep -vE '(^#|^$)' /etc/crontab
