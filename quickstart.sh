#!/bin/bash
# Quick start script for local development

echo "🚀 Stock Analysis Bot - Quick Start"
echo "===================================="
echo ""

# Check dependencies
echo "✓ Checking dependencies..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Install from https://python.org"
    exit 1
fi

if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Install from https://nodejs.org"
    exit 1
fi

echo "✓ Python 3 and Node.js found"
echo ""

# Backend Setup
echo "📦 Setting up Backend..."
cd backend

# Create venv
python3 -m venv venv
source venv/bin/activate 2>/dev/null || venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

echo "✓ Backend dependencies installed"
echo ""

# Frontend Setup
echo "📦 Setting up Frontend..."
cd ../frontend

npm install

echo "✓ Frontend dependencies installed"
echo ""

# Create .env files
echo "⚙️  Setting up environment files..."
cd ..

cat > backend/.env << EOF
PYTHONUNBUFFERED=1
API_HOST=0.0.0.0
API_PORT=8000
DEBUG=True
ALLOWED_ORIGINS=http://localhost:3000
EOF

cat > frontend/.env << EOF
REACT_APP_API_URL=http://localhost:8000
EOF

echo "✓ Environment files created"
echo ""

echo "✅ Setup Complete!"
echo ""
echo "🎯 Next Steps:"
echo ""
echo "Terminal 1 - Backend (FastAPI):"
echo "  cd backend"
echo "  source venv/bin/activate  # or venv\\Scripts\\activate on Windows"
echo "  python main.py"
echo ""
echo "Terminal 2 - Frontend (React):"
echo "  cd frontend"
echo "  npm start"
echo ""
echo "📍 Access the app at: http://localhost:3000"
echo "📚 API Docs at: http://localhost:8000/docs"
