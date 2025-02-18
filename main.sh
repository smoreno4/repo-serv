#!/bin/bash

# Definir colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

# Función para mostrar interfaces de red
mostrar_interfaces() {
    echo -e "${BLUE}===== Reporte de Interfaces de Red =====${NC}"
    echo "Fecha: $(date)"
    echo -e "=========================="
    
    ip a | grep -E '^\d+:' | while read -r line; do
        interface=$(echo "$line" | cut -d: -f2 | xargs)
        ip_address=$(ip addr show $interface | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
        
        if [ -n "$ip_address" ]; then
            echo -e "${GREEN}$interface${NC}"
            echo -e "IP: ${YELLOW}$ip_address${NC}"
            echo
        fi
    done
}

# Función para mostrar los cron jobs del sistema y root
mostrar_cron() {
    echo -e "${BLUE}===== Reporte de Cron Jobs =====${NC}"
    echo "Fecha: $(date)"
    echo -e "=========================="
    
    # Mostrar cron jobs del sistema
    echo -e "${GREEN}/etc/crontab:${NC}"
    cat /etc/crontab | grep -v '^#'  # Excluye comentarios

    # Mostrar cron jobs de root
    echo -e "${GREEN}Cron Jobs de root:${NC}"
    crontab -l -u root
}

# Ejecutar las funciones
mostrar_interfaces
mostrar_cron
