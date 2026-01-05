@echo off
REM Quick start script for Windows

echo.
echo 🚀 Stock Analysis Bot - Quick Start (Windows)
echo =============================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Python 3 not found. Install from https://python.org
    exit /b 1
)
echo ✓ Python 3 found

REM Check Node
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js not found. Install from https://nodejs.org
    exit /b 1
)
echo ✓ Node.js found
echo.

REM Backend Setup
echo 📦 Setting up Backend...
cd backend

REM Create venv with delayed expansion
setlocal enabledelayedexpansion
python -m venv venv 2>nul

REM Activate venv
if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
) else (
    echo Warning: venv activation failed, using system Python
)

REM Install requirements
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

echo ✓ Backend dependencies installed
echo.

REM Frontend Setup
echo 📦 Setting up Frontend...
cd ..\frontend

call npm install

echo ✓ Frontend dependencies installed
echo.

REM Create .env files
echo ⚙️  Setting up environment files...
cd ..

(
echo PYTHONUNBUFFERED=1
echo API_HOST=0.0.0.0
echo API_PORT=8000
echo DEBUG=True
echo ALLOWED_ORIGINS=http://localhost:3000
) > backend\.env

(
echo REACT_APP_API_URL=http://localhost:8000
) > frontend\.env

echo ✓ Environment files created
echo.

echo ✅ Setup Complete!
echo.
echo 🎯 Next Steps:
echo.
echo Command Prompt 1 - Backend (FastAPI):
echo   cd backend
echo   venv\Scripts\activate
echo   python main.py
echo.
echo Command Prompt 2 - Frontend (React):
echo   cd frontend
echo   npm start
echo.
echo 📍 Access the app at: http://localhost:3000
echo 📚 API Docs at: http://localhost:8000/docs
