#!/bin/bash
# DigitalOcean Droplet Deployment Script

set -e

DROPLET_IP="${1:-}"
DOMAIN="${2:-}"
GITHUB_REPO="${3:-}"

if [ -z "$DROPLET_IP" ] || [ -z "$DOMAIN" ] || [ -z "$GITHUB_REPO" ]; then
    echo "Usage: ./deploy-do-droplet.sh <DROPLET_IP> <DOMAIN> <GITHUB_REPO>"
    echo "Example: ./deploy-do-droplet.sh 192.168.1.100 yourdomain.com username/stockimageanalyzer"
    exit 1
fi

echo "🚀 Deploying Stock Analysis Bot to DigitalOcean Droplet"
echo "IP: $DROPLET_IP"
echo "Domain: $DOMAIN"
echo "Repo: $GITHUB_REPO"

# Function to run commands on droplet
run_on_droplet() {
    ssh -o StrictHostKeyChecking=no root@$DROPLET_IP "$@"
}

echo "📡 Installing Docker & Docker Compose..."
run_on_droplet << 'DOCKER_INSTALL'
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker root

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
DOCKER_INSTALL

echo "📦 Cloning repository..."
run_on_droplet "cd /opt && git clone https://github.com/$GITHUB_REPO.git stockimageanalyzer && cd stockimageanalyzer"

echo "⚙️ Setting environment variables..."
run_on_droplet << EOF
cat > /opt/stockimageanalyzer/backend/.env << ENVEOF
ENVIRONMENT=production
CORS_ORIGINS=https://$DOMAIN,https://www.$DOMAIN
ENVEOF

cat > /opt/stockimageanalyzer/frontend/.env.production << ENVEOF
REACT_APP_API_URL=https://api.$DOMAIN
ENVEOF
EOF

echo "🐳 Starting Docker containers..."
run_on_droplet "cd /opt/stockimageanalyzer && docker-compose up -d"

echo "📡 Installing Nginx..."
run_on_droplet << 'NGINX_INSTALL'
apt-get update
apt-get install -y nginx certbot python3-certbot-nginx
NGINX_INSTALL

echo "⚙️ Configuring Nginx..."
run_on_droplet << EOF
cat > /etc/nginx/sites-available/stock-analyzer << 'NGINXEOF'
upstream backend {
    server localhost:8000;
}

upstream frontend {
    server localhost:3000;
}

server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://frontend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /api {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
NGINXEOF

ln -sf /etc/nginx/sites-available/stock-analyzer /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx
EOF

echo "🔒 Setting up SSL with Let's Encrypt..."
run_on_droplet "certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN"

echo "🔄 Setting up auto-updates..."
run_on_droplet << 'CRON_SETUP'
cat > /opt/update-stock-analyzer.sh << 'UPDATEEOF'
#!/bin/bash
cd /opt/stockimageanalyzer
git pull origin main
docker-compose down
docker-compose up -d
UPDATEEOF

chmod +x /opt/update-stock-analyzer.sh
(crontab -l 2>/dev/null; echo "0 * * * * /opt/update-stock-analyzer.sh >> /var/log/stock-analyzer.log 2>&1") | crontab -
CRON_SETUP

echo "✅ Deployment complete!"
echo ""
echo "📊 Your app is live at:"
echo "  https://$DOMAIN"
echo "  https://www.$DOMAIN"
echo ""
echo "🔧 Management commands:"
echo "  View logs: ssh root@$DROPLET_IP 'docker-compose -f /opt/stockimageanalyzer/docker-compose.yml logs -f'"
echo "  Restart: ssh root@$DROPLET_IP 'docker-compose -f /opt/stockimageanalyzer/docker-compose.yml restart'"
echo "  Update: ssh root@$DROPLET_IP '/opt/update-stock-analyzer.sh'"
echo ""
echo "📝 Update DNS records:"
echo "  A Record: yourdomain.com → $DROPLET_IP"
echo "  A Record: www.yourdomain.com → $DROPLET_IP"
