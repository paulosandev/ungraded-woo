#!/bin/bash

# Configuración
LOCAL_URL="http://tu-sitio.local"
STAGING_URL="http://72.60.121.181"
STAGING_USER="deployer"
STAGING_HOST="72.60.121.181"

echo "📤 Enviando DB local a staging..."

# Exportar DB local
wp db export temp.sql

# Reemplazar URLs
wp search-replace "$LOCAL_URL" "$STAGING_URL" --export=staging.sql

# Enviar al servidor
scp staging.sql $STAGING_USER@$STAGING_HOST:/tmp/

# Importar en staging
ssh $STAGING_USER@$STAGING_HOST "cd /var/www/staging && wp db import /tmp/staging.sql && wp cache flush"

# Limpiar
rm temp.sql staging.sql
ssh $STAGING_USER@$STAGING_HOST "rm /tmp/staging.sql"

echo "✅ DB sincronizada!"
