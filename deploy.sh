#!/bin/bash
# Deployment script for Stock Analysis Bot to Google Cloud

set -e

PROJECT_ID="${1:-stock-analysis-bot}"
REGION="${2:-us-central1}"
DOMAIN="${3:-}"

echo "🚀 Deploying Stock Analysis Bot to Google Cloud"
echo "Project: $PROJECT_ID"
echo "Region: $REGION"

# Step 1: Enable APIs
echo "📡 Enabling required Google Cloud APIs..."
gcloud services enable run.googleapis.com \
    cloudbuild.googleapis.com \
    container.googleapis.com \
    firebase.googleapis.com \
    --project=$PROJECT_ID

# Step 2: Build and push backend image
echo "🔨 Building backend Docker image..."
cd backend
gcloud builds submit --tag gcr.io/$PROJECT_ID/stock-analyzer-api:latest \
    --project=$PROJECT_ID
cd ..

# Step 3: Deploy backend to Cloud Run
echo "☁️ Deploying backend to Cloud Run..."
BACKEND_URL=$(gcloud run deploy stock-analyzer-api \
    --image gcr.io/$PROJECT_ID/stock-analyzer-api:latest \
    --platform managed \
    --region $REGION \
    --memory 2Gi \
    --cpu 1 \
    --allow-unauthenticated \
    --project=$PROJECT_ID \
    --format='value(status.url)' \
    --quiet)

echo "✅ Backend deployed at: $BACKEND_URL"

# Step 4: Build and deploy frontend
echo "🎨 Building React frontend..."
cd frontend
npm run build
echo "🔥 Deploying to Firebase Hosting..."
firebase deploy --project=$PROJECT_ID
cd ..

echo "🎉 Deployment complete!"
echo ""
echo "Backend URL: $BACKEND_URL"
echo "Frontend URL: Check firebase console for your domain"
echo ""
if [ -n "$DOMAIN" ]; then
    echo "Next steps:"
    echo "1. Update DNS records for your domain ($DOMAIN)"
    echo "2. Configure custom domains in Cloud Run and Firebase consoles"
    echo "3. Update backend CORS origins in main.py"
    echo "4. Redeploy backend with: gcloud run deploy stock-analyzer-api --update-env-vars CORS_ORIGINS=\"https://$DOMAIN\""
fi
