@echo off
REM Stock Analyzer Electron Setup Script

echo.
echo ====================================
echo Stock Analyzer - Desktop App Setup
echo ====================================
echo.

REM Check if npm is installed
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: npm is not installed or not in PATH
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

REM Check if Python is installed
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://www.python.org/
    pause
    exit /b 1
)

echo ✓ Node.js found
echo ✓ Python found
echo.

echo Installing Electron dependencies...
call npm install electron electron-builder electron-is-dev concurrently wait-on
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install Electron dependencies
    pause
    exit /b 1
)

echo.
echo Installing frontend dependencies...
cd frontend
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install frontend dependencies
    cd ..
    pause
    exit /b 1
)
cd ..

echo.
echo Installing backend dependencies...
cd backend
python -m pip install -r requirements.txt
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Failed to install backend dependencies
    cd ..
    pause
    exit /b 1
)
cd ..

echo.
echo ====================================
echo ✅ Setup complete!
echo ====================================
echo.
echo Next steps:
echo.
echo 1. Start the app (development mode):
echo    npm start
echo.
echo 2. Create desktop shortcut:
echo    powershell -ExecutionPolicy Bypass -File create-shortcut.ps1
echo.
echo 3. Build installer (for distribution):
echo    npm run build
echo.
pause
