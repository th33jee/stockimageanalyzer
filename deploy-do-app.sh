#!/bin/bash
# DigitalOcean App Platform Deployment Script

set -e

APP_NAME="stock-analyzer"
GITHUB_REPO="YOUR_GITHUB_USERNAME/stockimageanalyzer"
DOMAIN="yourdomain.com"

echo "🚀 Deploying to DigitalOcean App Platform"
echo "App Name: $APP_NAME"
echo "GitHub Repo: $GITHUB_REPO"
echo "Domain: $DOMAIN"

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "❌ doctl CLI not found. Install from: https://docs.digitalocean.com/reference/doctl/how-to/install/"
    exit 1
fi

# Verify GitHub auth
echo "🔐 Verifying DigitalOcean authentication..."
doctl auth list

# Create app spec
cat > app_spec.yaml << EOF
name: $APP_NAME
services:
- name: backend
  github:
    repo: $GITHUB_REPO
    branch: main
    deploy_on_push: true
  build_command: pip install -r requirements.txt
  dockerfile_path: Dockerfile
  http_port: 8000
  source_dir: backend
  envs:
  - key: ENVIRONMENT
    scope: RUN_AND_BUILD_TIME
    value: production
  - key: CORS_ORIGINS
    scope: RUN_AND_BUILD_TIME
    value: https://$DOMAIN,https://www.$DOMAIN

- name: frontend
  github:
    repo: $GITHUB_REPO
    branch: main
    deploy_on_push: true
  build_command: npm ci && npm run build
  dockerfile_path: Dockerfile.prod
  source_dir: frontend
  http_port: 80
  envs:
  - key: REACT_APP_API_URL
    scope: BUILD_TIME
    value: https://api.$DOMAIN

static_sites:
- source_dir: frontend/build
  github:
    repo: $GITHUB_REPO
    branch: main
  routes:
  - path: /

domains:
- name: $DOMAIN
- name: www.$DOMAIN
EOF

echo "📋 Created app specification"

# Create app
echo "⚙️ Creating DigitalOcean App..."
doctl apps create --spec app_spec.yaml

echo "✅ App created! Deployment in progress..."
echo ""
echo "Next steps:"
echo "1. Go to https://cloud.digitalocean.com/apps to monitor deployment"
echo "2. Update your domain's DNS to point to DigitalOcean"
echo "3. Enable auto-SSL in App Settings"
echo ""
echo "View deployment status:"
echo "  doctl apps list"
echo "  doctl apps get <app-id> --format info"
