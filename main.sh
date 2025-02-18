#!/bin/bash

# Definición de colores
TITULO='\033[1;36m'  # Cyan brillante para título
INTERFACE='\033[1;33m'  # Amarillo para nombre de la interfaz
IP_COLOR='\033[1;32m'  # Verde brillante para la IP
RESET='\033[0m'  # Resetear color

# Título
echo -e "${TITULO}===== Reporte de Interfaces de Red =====${RESET}"
echo -e "${TITULO}Fecha: $(date)${RESET}"
echo -e "${TITULO}==========================${RESET}\n"

# Filtrar interfaces y mostrar nombre e inet (IP)
INTERFACE_NAME=""
IP=""

ip a | while read -r line; do
    # Mostrar nombre de la interfaz
    if echo "$line" | grep -q '^[0-9]'; then
        # Guardar nombre de la interfaz
        INTERFACE_NAME=$(echo "$line" | awk -F: '{print $2}' | tr -d ' ')
    fi

    # Mostrar dirección inet (IP)
    if echo "$line" | grep -q 'inet '; then
        # Guardar la IP
        IP=$(echo "$line" | awk '{print $2}' | sed 's/\/.*//')

        # Solo mostrar interfaces con IP
        if [ -n "$IP" ]; then
            echo -e "\n${INTERFACE}${INTERFACE_NAME}${RESET}"
            echo -e "${IP_COLOR}IP: ${IP}${RESET}"
        fi
    fi
done
