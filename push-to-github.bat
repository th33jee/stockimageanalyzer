@echo off
REM Push Stock Analyzer to GitHub (Windows PowerShell version)

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Usage: push-to-github.bat ^<GITHUB_USERNAME^> [REPO_NAME] [GITHUB_TOKEN]
    echo.
    echo Example:
    echo   push-to-github.bat john-doe stockimageanalyzer ghp_1234567890abcdef
    echo.
    echo Or use SSH (recommended):
    echo   push-to-github.bat john-doe stockimageanalyzer ssh
    echo.
    echo Setup Instructions:
    echo   1. Create repo on GitHub: https://github.com/new
    echo   2. Create Personal Access Token: https://github.com/settings/tokens
    echo   3. Run this script with your credentials
    exit /b 1
)

set GITHUB_USERNAME=%~1
set REPO_NAME=%~2
if "!REPO_NAME!"=="" set REPO_NAME=stockimageanalyzer
set GITHUB_TOKEN=%~3

echo 🚀 Pushing Stock Analyzer to GitHub
echo Username: !GITHUB_USERNAME!
echo Repository: !REPO_NAME!

REM Initialize git if needed
if not exist ".git" (
    echo 📝 Initializing Git repository...
    git init
    git config user.email "you@example.com"
    git config user.name "!GITHUB_USERNAME!"
)

REM Add files
echo 📦 Adding files...
git add .

REM Create commit
echo 💾 Creating commit...
git commit -m "Initial commit: Stock Chart Analysis Bot with improved ML training"

REM Determine repository URL
if "!GITHUB_TOKEN!"=="ssh" (
    set REPO_URL=git@github.com:!GITHUB_USERNAME!/!REPO_NAME!.git
    echo Using SSH: !REPO_URL!
) else if not "!GITHUB_TOKEN!"=="" (
    set REPO_URL=https://!GITHUB_USERNAME!:!GITHUB_TOKEN!@github.com/!GITHUB_USERNAME!/!REPO_NAME!.git
    echo Using Token Authentication
) else (
    set REPO_URL=https://github.com/!GITHUB_USERNAME!/!REPO_NAME!.git
    echo Using HTTPS ^(you'll be prompted for password^)
)

REM Check if remote exists
git remote get-url origin >nul 2>&1
if !errorlevel! equ 0 (
    echo 🔄 Updating remote origin...
    git remote set-url origin "!REPO_URL!"
) else (
    echo 🔗 Adding remote origin...
    git remote add origin "!REPO_URL!"
)

REM Push to GitHub
echo 🚀 Pushing to GitHub...
git branch -M main
git push -u origin main

echo ✅ Successfully pushed to GitHub!
echo.
echo Repository: https://github.com/!GITHUB_USERNAME!/!REPO_NAME!
echo.
echo Next steps:
echo 1. Create a .env.production file with your domain
echo 2. Deploy using one of the deployment guides:
echo    - Google Cloud: DEPLOYMENT_GUIDE.md
echo    - DigitalOcean: DIGITALOCEAN_DEPLOYMENT.md

endlocal
