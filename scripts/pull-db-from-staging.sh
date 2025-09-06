#!/bin/bash

# Configuración
LOCAL_URL="http://ungraded-woo.local/"
STAGING_URL="http://72.60.121.181"
STAGING_USER="deployer"
STAGING_HOST="72.60.121.181"

echo "📥 Trayendo DB de staging..."

# Exportar de staging
ssh $STAGING_USER@$STAGING_HOST "cd /var/www/staging && wp db export -" > staging.sql

# Importar en local
wp db import staging.sql

# Reemplazar URLs
wp search-replace "$STAGING_URL" "$LOCAL_URL"

# Limpiar
rm staging.sql
wp cache flush

echo "✅ DB sincronizada!"
