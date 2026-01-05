# Deployment Checklist for moneyboy.tech

## Pre-Deployment Checklist

### Code Quality
- [ ] All tests passing (`pytest` and `npm test`)
- [ ] No console errors or warnings
- [ ] ESLint checks passed (frontend)
- [ ] No security vulnerabilities (`pip audit`, `npm audit`)
- [ ] Code is properly documented
- [ ] Environment variables configured

### Backend Configuration
- [ ] `requirements.txt` up to date
- [ ] `.env.example` matches actual `.env`
- [ ] Database migrations completed (if applicable)
- [ ] API endpoints tested with Postman/Insomnia
- [ ] CORS origins set to production domain
- [ ] Debug mode disabled
- [ ] Logging configured appropriately

### Frontend Configuration
- [ ] `package.json` dependencies installed
- [ ] Build optimization enabled (`npm run build`)
- [ ] API URLs point to production backend
- [ ] No hardcoded localhost URLs
- [ ] Meta tags and SEO configured
- [ ] Images optimized
- [ ] Service worker configured (for offline support)

### Security
- [ ] SSL/TLS certificates obtained (Let's Encrypt)
- [ ] HTTPS enforced
- [ ] Security headers configured in nginx
- [ ] CORS properly configured
- [ ] Rate limiting enabled
- [ ] Input validation on backend
- [ ] File upload size limits set
- [ ] Secret keys rotated and secured

### Infrastructure
- [ ] Server/VPS provisioned and updated
- [ ] Docker installed and configured
- [ ] Docker Compose installed
- [ ] Nginx installed or container image ready
- [ ] Firewall rules configured
- [ ] SSH keys secured
- [ ] Backups configured

---

## Step-by-Step Deployment Guide

### 1. Server Setup (AWS EC2 / VPS)

```bash
# SSH into server
ssh -i your-key.pem ubuntu@your-server-ip

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### 2. Clone Repository

```bash
cd /home/ubuntu
git clone https://github.com/yourname/stockimageanalyzer.git
cd stockimageanalyzer
```

### 3. Configure Environment

```bash
# Backend
cp backend/.env.example backend/.env
nano backend/.env
# Edit with production values

# Frontend
cp frontend/.env.example frontend/.env
nano frontend/.env
# Set REACT_APP_API_URL=https://api.moneyboy.tech
```

### 4. Setup SSL Certificates

```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --standalone -d moneyboy.tech -d www.moneyboy.tech
# Follow prompts

# Verify certificate
ls /etc/letsencrypt/live/moneyboy.tech/
```

### 5. Configure Nginx

```bash
# Copy nginx config
sudo cp nginx.conf /etc/nginx/sites-available/moneyboy.tech

# Update certificate paths in nginx.conf
sudo nano /etc/nginx/sites-available/moneyboy.tech

# Create symlink
sudo ln -s /etc/nginx/sites-available/moneyboy.tech /etc/nginx/sites-enabled/

# Test nginx config
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx
```

### 6. Deploy with Docker Compose

```bash
# Create production compose file
cp docker-compose.yml docker-compose.prod.yml
nano docker-compose.prod.yml
# Update ports and environment variables

# Build and deploy
docker-compose -f docker-compose.prod.yml up -d

# Verify containers
docker-compose ps
docker-compose logs -f
```

### 7. Configure Auto-Renewal

```bash
# Certbot auto-renewal
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer

# Verify
sudo systemctl status certbot.timer
```

### 8. Setup Monitoring

```bash
# Install monitoring tool (optional)
# Using PM2 for process management
sudo npm install -g pm2

# Setup PM2 startup
pm2 startup
pm2 save
```

### 9. DNS Configuration

In your domain registrar (GoDaddy, Namecheap, etc.):

```
Type: A Record
Name: @ (for moneyboy.tech)
Value: your-server-ip

Type: CNAME Record
Name: www
Value: moneyboy.tech

Type: A Record
Name: api
Value: your-server-ip (if using separate API domain)
```

### 10. Verify Deployment

```bash
# Check website
curl https://moneyboy.tech
curl https://api.moneyboy.tech/health

# Check SSL
curl -I https://moneyboy.tech
# Should show: HTTP/2 200

# Check Docker logs
docker-compose logs backend
docker-compose logs frontend

# Check system resources
docker stats
```

---

## Maintenance & Monitoring

### Daily Checks
```bash
# Check container status
docker-compose ps

# Monitor logs
docker-compose logs --tail=50 -f

# Check disk space
df -h
```

### Weekly Maintenance
```bash
# Update images
docker-compose pull
docker-compose up -d

# Prune unused resources
docker system prune

# Backup database (if applicable)
# mysqldump or pg_dump commands
```

### Monthly Updates
```bash
# Update Ubuntu packages
sudo apt-get update
sudo apt-get upgrade

# Update Python dependencies
docker exec stock-analyzer-backend pip install --upgrade -r requirements.txt

# Update Node dependencies
docker exec stock-analyzer-frontend npm update
```

---

## Rollback Procedure

### If something goes wrong:

```bash
# Stop current deployment
docker-compose down

# Revert to previous version
git checkout previous-commit-hash
docker-compose up -d

# Or restore from backup
# Restore database from backup
# Restart services
```

---

## Performance Optimization

### Caching
```bash
# Clear cache if needed
docker exec stock-analyzer-backend redis-cli FLUSHALL
```

### Load Balancing
```yaml
# In docker-compose.yml
services:
  backend:
    deploy:
      replicas: 3  # Run 3 instances
    restart_policy:
      condition: on-failure
```

### Database Optimization
```bash
# Analyze query performance
# Index frequently searched columns
# Archive old data regularly
```

---

## Troubleshooting

### Container won't start
```bash
docker-compose logs backend
docker-compose logs frontend
# Check error messages and docker resource limits
```

### High memory usage
```bash
docker stats
# Check for memory leaks in application
# Increase container memory limits
```

### CORS errors
```
Edit backend/.env
Update ALLOWED_ORIGINS
docker-compose restart backend
```

### SSL certificate issues
```bash
sudo certbot certificates
sudo certbot renew --dry-run
```

---

## Disaster Recovery

### Daily Backup
```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y-%m-%d)
docker-compose exec -T postgres pg_dump > backup-$DATE.sql
```

### Restore from Backup
```bash
# Stop application
docker-compose down

# Restore database
cat backup-2024-01-05.sql | docker-compose exec -T postgres psql

# Restart
docker-compose up -d
```

---

## Success Criteria

✅ **Deployment is successful when:**

- [ ] Website loads at https://moneyboy.tech
- [ ] API responds at https://api.moneyboy.tech/health
- [ ] SSL certificate valid (no browser warnings)
- [ ] Image upload works
- [ ] Analysis completes in <10 seconds
- [ ] All features functional
- [ ] No 5xx errors in logs
- [ ] Mobile responsive
- [ ] Containers healthy
- [ ] Auto-renewal working

---

## Post-Deployment

### Monitor Performance
- Set up uptime monitoring (UptimeRobot, Pingdom)
- Monitor error rates (Sentry)
- Track user analytics
- Performance monitoring (New Relic, DataDog)

### User Communication
- Announce deployment on social media
- Send email to users
- Update status page
- Document changes in changelog

### Continuous Improvement
- Gather user feedback
- Monitor error logs
- Optimize slow endpoints
- Plan for next release

---

**Deployment Date**: ___________
**Deployed By**: ___________
**Version**: ___________
**Notes**: ___________

---

For issues during deployment, refer to [SETUP_GUIDE.md](SETUP_GUIDE.md) or contact support@moneyboy.tech
