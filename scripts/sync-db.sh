#!/bin/bash

# === CONFIGURACIÓN ===
SERVER_IP="72.60.121.181"
SERVER_USER="root"
LOCAL_URL="http://tu-sitio.local"  # CAMBIA ESTO
REMOTE_URL="http://72.60.121.181"

echo "⚠️  ADVERTENCIA: Esto reemplazará la BD del servidor"
read -p "¿Continuar? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado."
    exit 1
fi

# Hacer backup primero
echo "📸 Creando backup de seguridad..."
./backup.sh

# Exportar BD local
echo "📤 Exportando BD local..."
cd ..
wp db export temp.sql

# Reemplazar URLs
wp search-replace "$LOCAL_URL" "$REMOTE_URL" --export=para-servidor.sql

# Subir al servidor
echo "📤 Subiendo BD al servidor..."
scp para-servidor.sql $SERVER_USER@$SERVER_IP:/tmp/

# Importar en el servidor
echo "📥 Importando en el servidor..."
ssh $SERVER_USER@$SERVER_IP "cd /var/www/staging && wp db import /tmp/para-servidor.sql --allow-root && wp cache flush --allow-root"

# Limpiar archivos temporales
rm temp.sql para-servidor.sql
ssh $SERVER_USER@$SERVER_IP "rm /tmp/para-servidor.sql"

echo "✅ BD sincronizada!"
