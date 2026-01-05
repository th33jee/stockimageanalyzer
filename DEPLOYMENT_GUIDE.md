# Google Cloud Deployment Guide for Stock Analysis Bot

## Prerequisites
- Google Cloud Account with billing enabled
- `gcloud` CLI installed
- `firebase-tools` installed (`npm install -g firebase-tools`)
- Docker installed

## Step 1: Set Up Google Cloud Project

```bash
# Set your project ID
export PROJECT_ID="your-google-project-id"

# Set project
gcloud config set project $PROJECT_ID

# Enable required APIs
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

## Step 2: Deploy Backend to Cloud Run

```bash
# Navigate to backend folder
cd backend

# Build and push Docker image to Google Container Registry
gcloud builds submit --tag gcr.io/$PROJECT_ID/stock-analyzer-api:latest

# Deploy to Cloud Run
gcloud run deploy stock-analyzer-api \
  --image gcr.io/$PROJECT_ID/stock-analyzer-api:latest \
  --platform managed \
  --region us-central1 \
  --memory 2Gi \
  --cpu 1 \
  --allow-unauthenticated \
  --set-env-vars CORS_ORIGINS="https://yourdomain.com,https://www.yourdomain.com"
```

After deployment, you'll get a Cloud Run URL like: `https://stock-analyzer-api-xxxxx.run.app`

## Step 3: Deploy Frontend to Firebase

```bash
# Navigate to frontend folder
cd frontend

# Create production build
npm run build

# Initialize Firebase (first time only)
firebase init hosting

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

## Step 4: Configure Custom Domain

### Option A: Use Google Domains
1. Go to Google Cloud Console > Cloud Run > stock-analyzer-api
2. Click "Manage Custom Domains"
3. Select your domain and subdomain (e.g., api.yourdomain.com)
4. Verify DNS records

### Option B: Update your Domain's DNS Records

For Backend (api.yourdomain.com):
- Point to Cloud Run CNAME (provided in console)

For Frontend (yourdomain.com):
- Firebase Hosting will provide DNS records in console

## Step 5: Update Environment Variables

### Update Backend CORS Origins
Edit `backend/main.py` and update:
```python
origins = [
    "https://yourdomain.com",
    "https://www.yourdomain.com",
    "https://api.yourdomain.com",
]
```

### Update Frontend API URL
Edit `frontend/.env` or create `.env.production`:
```
REACT_APP_API_URL=https://api.yourdomain.com
```

Then redeploy both.

## Step 6: Set Up CI/CD (Optional but Recommended)

Create `.github/workflows/deploy.yml` for automatic deployments on push.

## Monitoring & Logs

```bash
# View Cloud Run logs
gcloud run logs read stock-analyzer-api --limit 100

# View Firebase Hosting deployment
firebase deploy --list
```

## Cost Estimation
- Cloud Run: ~$0.00002400 per request + CPU/memory costs (free tier: 2M requests/month)
- Firebase Hosting: Free tier includes 10GB/month bandwidth
- Total: Usually <$5/month for low traffic

## Troubleshooting

### 403 Forbidden errors
- Check CORS origins in backend/main.py
- Ensure domain is added to Firebase Hosting settings

### API calls failing from frontend
- Verify REACT_APP_API_URL is correct
- Check Cloud Run service URL is accessible
- Review CORS middleware in main.py

### High latency
- Scale Cloud Run instance count in console
- Use Cloud CDN for frontend caching
