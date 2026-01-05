# DigitalOcean Deployment Guide

## Option 1: DigitalOcean App Platform (Easiest - Recommended)

### Prerequisites
- DigitalOcean Account
- GitHub account with your repo pushed
- doctl CLI (optional but helpful)

### Step 1: Push to GitHub
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/stockimageanalyzer.git
git branch -M main
git push -u origin main
```

### Step 2: Create App on DigitalOcean
1. Go to DigitalOcean Dashboard > Apps
2. Click "Create Apps"
3. Select GitHub and authorize
4. Select your `stockimageanalyzer` repository
5. Click "Next"

### Step 3: Configure Services
The `app.yaml` file in root handles this automatically, or configure manually:

**Backend Service:**
- Source: GitHub repo → backend folder
- Build: Dockerfile
- HTTP Port: 8000
- Environment Variables:
  - `CORS_ORIGINS`: https://yourdomain.com
  
**Frontend Service:**
- Source: GitHub repo → frontend folder  
- Build: `npm install && npm run build`
- Environment Variables:
  - `REACT_APP_API_URL`: https://api.yourdomain.com

### Step 4: Set Custom Domain
1. In App Settings > Domains
2. Add your custom domain
3. Update DNS records to point to DigitalOcean

### Estimated Cost
- **App Platform**: $5-12/month (very affordable)
- Includes automatic deployments on git push
- Automatic HTTPS/SSL

---

## Option 2: DigitalOcean Droplet + Docker Compose (Cheapest)

### Cost: $4-6/month for basic Droplet

### Step 1: Create Droplet
```bash
# Via CLI
doctl compute droplet create stock-analyzer \
  --region nyc3 \
  --image ubuntu-22-04-x64 \
  --size s-1vcpu-1gb \
  --enable-monitoring
```

### Step 2: SSH into Droplet
```bash
ssh root@YOUR_DROPLET_IP
```

### Step 3: Install Docker & Docker Compose
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Step 4: Clone Repository
```bash
cd /opt
sudo git clone https://github.com/YOUR_USERNAME/stockimageanalyzer.git
cd stockimageanalyzer
```

### Step 5: Set Environment Variables
```bash
# Create .env file
cat > backend/.env << EOF
ENVIRONMENT=production
CORS_ORIGINS=https://yourdomain.com,https://www.yourdomain.com
EOF

cat > frontend/.env.production << EOF
REACT_APP_API_URL=https://api.yourdomain.com
EOF
```

### Step 6: Start Services
```bash
sudo docker-compose up -d
```

### Step 7: Set Up Nginx Reverse Proxy
```bash
sudo apt-get update
sudo apt-get install -y nginx certbot python3-certbot-nginx

# Create nginx config
sudo tee /etc/nginx/sites-available/stock-analyzer << EOF
upstream backend {
    server localhost:8000;
}

upstream frontend {
    server localhost:3000;
}

server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location /api {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }

    location / {
        proxy_pass http://frontend;
        proxy_set_header Host \$host;
    }
}
EOF

# Enable site
sudo ln -s /etc/nginx/sites-available/stock-analyzer /etc/nginx/sites-enabled/

# Test and restart
sudo nginx -t
sudo systemctl restart nginx

# Get SSL certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

### Step 8: Set Up Auto-Updates
```bash
# Create update script
cat > /opt/stockimageanalyzer/update.sh << EOF
#!/bin/bash
cd /opt/stockimageanalyzer
git pull origin main
docker-compose down
docker-compose up -d
EOF

chmod +x /opt/stockimageanalyzer/update.sh

# Add to cron (auto-update every hour)
echo "0 * * * * /opt/stockimageanalyzer/update.sh >> /var/log/stock-analyzer-update.log 2>&1" | sudo crontab -
```

### Step 9: Enable Monitoring
```bash
# View logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Monitor via DigitalOcean dashboard
# Droplet > Monitoring tab
```

### DNS Configuration
Update your domain's DNS records:
```
A Record:
  Name: yourdomain.com
  Value: YOUR_DROPLET_IP
  
A Record:
  Name: www
  Value: YOUR_DROPLET_IP
```

---

## Option 3: DigitalOcean Kubernetes (Most Scalable)

### Cost: $12/month base + compute
- Better for high traffic
- Auto-scaling
- Load balancing

```bash
# Create cluster
doctl kubernetes cluster create stock-analyzer \
  --region nyc3 \
  --node-pool name=default,size=s-1vcpu-2gb,count=2

# Deploy using kubectl
# (Requires kubernetes manifests - can provide if needed)
```

---

## Comparison Table

| Feature | App Platform | Droplet | Kubernetes |
|---------|--------------|---------|-----------|
| Cost | $5-12/month | $4-6/month | $12+/month |
| Setup Time | 5 min | 30 min | 60 min |
| Auto Deploy | ✅ Yes | ❌ Manual | ✅ Yes |
| SSL/HTTPS | ✅ Auto | ❌ Manual | ✅ Auto |
| Scaling | ✅ Easy | ❌ Manual | ✅ Auto |
| Best For | Quick launch | Budget | High traffic |

---

## Monitoring & Maintenance

### View Logs
```bash
# App Platform - via dashboard
# Droplet - via docker
docker-compose logs backend
docker-compose logs frontend
```

### Update Application
```bash
# App Platform - automatic on git push

# Droplet - manual
cd /opt/stockimageanalyzer
git pull
docker-compose restart
```

### Backup
```bash
# App Platform - automatic

# Droplet - manual backup
doctl compute droplet-snapshot create stock-analyzer --snapshot-name stock-analyzer-backup-$(date +%Y%m%d)
```

---

## Troubleshooting

### API returns 503
```bash
# Check backend is running
docker-compose ps
docker-compose logs backend
```

### CORS errors
- Verify `CORS_ORIGINS` env var in backend
- Restart: `docker-compose restart backend`

### Out of memory
- Upgrade Droplet size: doctl compute droplet resize stock-analyzer --size s-2vcpu-2gb
