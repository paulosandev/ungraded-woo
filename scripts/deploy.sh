#!/bin/bash

# === CONFIGURACIÓN ===
SERVER_IP="72.60.121.181"
SERVER_USER="root"  # Usamos root por simplicidad
SERVER_PATH="/var/www/staging"

echo "🚀 Deploy Manual a Servidor"
echo "=========================="

# Preguntar confirmación
read -p "¿Subir archivos al servidor? (s/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Ss]$ ]]; then
    echo "Cancelado."
    exit 1
fi

# Subir archivos del tema (ajusta la ruta a tu tema)
echo "📤 Subiendo archivos..."
rsync -avz --progress \
    --exclude '.git' \
    --exclude 'node_modules' \
    --exclude '.DS_Store' \
    --exclude '*.log' \
    --exclude 'wp-config.php' \
    --exclude 'wp-content/uploads' \
    ../wp-content/themes/ \
    $SERVER_USER@$SERVER_IP:$SERVER_PATH/wp-content/themes/

# Subir plugins personalizados si tienes
# rsync -avz ../wp-content/plugins/mi-plugin-custom/ \
#     $SERVER_USER@$SERVER_IP:$SERVER_PATH/wp-content/plugins/mi-plugin-custom/

echo "✅ Deploy completado!"
echo "🌐 Ver en: http://$SERVER_IP"
