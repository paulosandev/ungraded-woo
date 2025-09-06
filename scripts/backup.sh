#!/bin/bash

# === CONFIGURACIÓN ===
SERVER_IP="72.60.121.181"
SERVER_USER="root"
BACKUP_DIR="../backups"

# Crear carpeta de backups si no existe
mkdir -p $BACKUP_DIR

echo "💾 Creando Backups..."

# Backup Local
echo "→ Backup local..."
cd ..
wp db export $BACKUP_DIR/local-$(date +%Y%m%d-%H%M%S).sql
echo "✓ Backup local creado"

# Backup Remoto
echo "→ Backup remoto..."
ssh $SERVER_USER@$SERVER_IP "cd /var/www/staging && wp db export --allow-root" > $BACKUP_DIR/remote-$(date +%Y%m%d-%H%M%S).sql
echo "✓ Backup remoto creado"

echo "✅ Backups guardados en $BACKUP_DIR"
ls -lh $BACKUP_DIR/*.sql | tail -2
