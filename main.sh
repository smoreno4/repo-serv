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
ip -br addr show | grep -E 'lo|eth|docker|br|veth|n4m' | while read line; do
    if echo "$line" | grep -q 'inet'; then
        interface=$(echo "$line" | awk '{print $1}')
        ip_address=$(echo "$line" | awk '{print $3}')
        color_echo "yellow" "$interface"
        color_echo "green" "IP: $ip_address"
        echo ""
    fi
done

# Reporte de Cron Jobs
color_echo "green" "===== Reporte de Cron Jobs ====="
echo ""

# Mostrar el contenido de /etc/crontab
color_echo "yellow" "Contenido de /etc/crontab:"
cat /etc/crontab
