#!/bin/bash

# Variables de configuración
TIEMPO_MAXIMO=15     # Tiempo máximo desde último cambio (minutos)
AVISO_TIEMPO=10      # Momento del aviso antes del forzado
USUARIO=$(logname)    # Obtener el nombre del usuario que inició sesión

# No aplicar a root
if [ "$USUARIO" == "root" ]; then
    exit 0
fi

# Obtener fecha del último cambio de contraseña
LAST_CHANGE=$(chage -l "$USUARIO" | grep "Last password change" | cut -d: -f2 | xargs)

# Si no hay fecha, forzar el cambio inmediato
if [ -z "$LAST_CHANGE" ]; then
    chage -d 0 "$USUARIO"
    echo "No hay fecha de último cambio de contraseña. Se forzó el cambio."
    exit 0
fi

LAST_CHANGE_TS=$(date -d "$LAST_CHANGE" +%s)
NOW_TS=$(date +%s)
ELAPSED_MIN=$(( (NOW_TS - LAST_CHANGE_TS) / 60 ))

# Forzar el cambio si ha pasado más de TIEMPO_MAXIMO
if [ "$ELAPSED_MIN" -ge "$TIEMPO_MAXIMO" ]; then
    echo "[$(date)] Forzando expiración de la contraseña de $USUARIO"
    chage -d 0 "$USUARIO"
    exit 0
# Avisar si faltan AVISO_TIEMPO minutos
elif [ "$ELAPSED_MIN" -ge "$AVISO_TIEMPO" ]; then
    wall "⚠️ QA: El usuario '$USUARIO' deberá cambiar su contraseña en menos de $((TIEMPO_MAXIMO - ELAPSED_MIN)) minutos."
fi

# Si la contraseña está caducada, forzar el cambio al iniciar sesión
EXPIRED=$(chage -l "$USUARIO" | grep "Password expires" | grep -qi "expired"; echo $?)

if [ "$EXPIRED" != "0" ]; then
    exit 0
fi

# Si está caducada, pedir el cambio de contraseña
echo "== QA de cambio obligatorio de contraseña para $USUARIO =="

while true; do
    read -s -p "Introduce una nueva contraseña para $USUARIO: " NUEVA_CONTRA
    echo
    read -s -p "Confirma la nueva contraseña: " CONFIRMACION
    echo

    # Verificar que las contraseñas coinciden
    if [[ "$NUEVA_CONTRA" != "$CONFIRMACION" ]]; then
        echo "❌ Las contraseñas no coinciden."
        continue
    fi

    # Verificar longitud mínima de la contraseña
    if [[ ${#NUEVA_CONTRA} -lt 12 ]]; then
        echo "❌ Mínimo 12 caracteres."
        continue
    fi

    # Verificar mayúsculas
    if ! [[ "$NUEVA_CONTRA" =~ [A-Z] ]]; then
        echo "❌ Falta una mayúscula."
        continue
    fi

    # Verificar minúsculas
    if ! [[ "$NUEVA_CONTRA" =~ [a-z] ]]; then
        echo "❌ Falta una minúscula."
        continue
    fi

    # Verificar números
    if ! [[ "$NUEVA_CONTRA" =~ [0-9] ]]; then
        echo "❌ Falta un número."
        continue
    fi

    # Verificar caracteres especiales
    if ! [[ "$NUEVA_CONTRA" =~ [\@\#\$\%\^\&\*\(\)\_\+\!\-\=] ]]; then
        echo "❌ Falta un carácter especial."
        continue
    fi

    break
done

# Cambiar la contraseña
echo "$USUARIO:$NUEVA_CONTRA" | sudo chpasswd
echo "✅ Contraseña cambiada correctamente para $USUARIO."

# Forzar la expiración inmediata para que se cambie en el próximo login
chage -d 0 "$USUARIO"
echo "Contraseña marcada como caducada. Se solicitará cambio en el siguiente login."
