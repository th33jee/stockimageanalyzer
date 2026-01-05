#!/bin/bash
# Push Stock Analyzer to GitHub

set -e

# Configuration
GITHUB_USERNAME="${1:-}"
REPO_NAME="${2:-stockimageanalyzer}"
GITHUB_TOKEN="${3:-}"

if [ -z "$GITHUB_USERNAME" ]; then
    echo "Usage: ./push-to-github.sh <GITHUB_USERNAME> [REPO_NAME] [GITHUB_TOKEN]"
    echo ""
    echo "Example:"
    echo "  ./push-to-github.sh john-doe stockimageanalyzer ghp_1234567890abcdef"
    echo ""
    echo "Or set up with SSH (recommended):"
    echo "  1. Add your SSH key to GitHub: https://github.com/settings/keys"
    echo "  2. Run: ./push-to-github.sh john-doe stockimageanalyzer ssh"
    exit 1
fi

echo "🚀 Pushing Stock Analyzer to GitHub"
echo "Username: $GITHUB_USERNAME"
echo "Repository: $REPO_NAME"

# Initialize git if needed
if [ ! -d ".git" ]; then
    echo "📝 Initializing Git repository..."
    git init
    git config user.email "you@example.com"
    git config user.name "$GITHUB_USERNAME"
fi

# Add files
echo "📦 Adding files..."
git add .

# Create commit
echo "💾 Creating commit..."
git commit -m "Initial commit: Stock Chart Analysis Bot with improved ML training"

# Determine repository URL
if [ "$GITHUB_TOKEN" = "ssh" ]; then
    REPO_URL="git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
    echo "Using SSH: $REPO_URL"
elif [ -n "$GITHUB_TOKEN" ]; then
    REPO_URL="https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    echo "Using Token Authentication"
else
    REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
    echo "Using HTTPS (you'll be prompted for password)"
fi

# Check if remote exists
if git remote get-url origin 2>/dev/null; then
    echo "🔄 Updating remote origin..."
    git remote set-url origin "$REPO_URL"
else
    echo "🔗 Adding remote origin..."
    git remote add origin "$REPO_URL"
fi

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git branch -M main
git push -u origin main

echo "✅ Successfully pushed to GitHub!"
echo ""
echo "Repository: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo ""
echo "Next steps:"
echo "1. Create a .env.production file with your domain"
echo "2. Deploy using one of the deployment guides:"
echo "   - Google Cloud: DEPLOYMENT_GUIDE.md"
echo "   - DigitalOcean: DIGITALOCEAN_DEPLOYMENT.md"
