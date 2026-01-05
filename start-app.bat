@echo off
REM Stock Analyzer Desktop App Startup Script

echo Starting Stock Analyzer...
echo.

REM Check if Node modules are installed
if not exist "node_modules" (
    echo Installing dependencies...
    call npm install
    if errorlevel 1 (
        echo Failed to install dependencies
        pause
        exit /b 1
    )
)

REM Check if frontend dependencies are installed
if not exist "frontend\node_modules" (
    echo Installing frontend dependencies...
    cd frontend
    call npm install
    cd ..
    if errorlevel 1 (
        echo Failed to install frontend dependencies
        pause
        exit /b 1
    )
)

REM Check if backend venv exists
if not exist "backend\venv" (
    echo Creating Python virtual environment...
    cd backend
    python -m venv venv
    call venv\Scripts\activate.bat
    pip install -r requirements.txt
    if errorlevel 1 (
        echo Failed to setup Python environment
        pause
        exit /b 1
    )
    cd ..
)

REM Start the app
echo.
echo All dependencies ready. Starting application...
echo.
timeout /t 2

npm start

pause
