# Stock Analysis Bot - Complete Setup Guide

## 🚀 Project Overview
This is a full-stack stock chart analysis bot that:
- Accepts candlestick chart images
- Performs AI-powered technical analysis
- Identifies patterns (reversal, continuation, chart patterns)
- Provides trading setups (SL, TP, prediction, strength)
- Displays results with visual strength bar (green/red)

## 📦 Tech Stack
- **Backend**: Python, FastAPI, OpenCV, NumPy, TensorFlow
- **Frontend**: React 18, Axios, Dropzone
- **Deployment**: Docker, nginx, AWS/VPS
- **Domain**: moneyboy.tech

## 🔧 Prerequisites
- Python 3.9+
- Node.js 16+
- Docker (for deployment)
- GPU support (optional, for faster processing)

## 📂 Project Structure
```
stockimageanalyzer/
├── backend/
│   ├── main.py                 # FastAPI application
│   ├── candlestick_analyzer.py # Core analysis engine
│   ├── requirements.txt        # Python dependencies
│   ├── Dockerfile             # Docker config
│   └── .env.example           # Environment variables
├── frontend/
│   ├── src/
│   │   ├── App.js            # Main React component
│   │   ├── App.css           # Main styles
│   │   ├── components/
│   │   │   ├── AnalysisResult.js
│   │   │   ├── StrengthBar.js
│   │   │   └── LoadingSpinner.js
│   │   ├── index.js
│   │   └── index.css
│   ├── package.json
│   ├── Dockerfile
│   └── .env.example
├── docker-compose.yml         # Container orchestration
├── nginx.conf                 # Web server config
└── README.md
```

---

## 🏃 Local Development Setup

### Backend Setup
```bash
cd backend

# Create virtual environment
python -m venv venv

# Activate
venv\Scripts\activate  # Windows
source venv/bin/activate  # Mac/Linux

# Install dependencies
pip install -r requirements.txt

# Run development server
python main.py
# Or: uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Backend runs on `http://localhost:8000`

### Frontend Setup
```bash
cd frontend

# Install dependencies
npm install

# Create .env file
echo REACT_APP_API_URL=http://localhost:8000 > .env

# Run development server
npm start
```

Frontend runs on `http://localhost:3000`

---

## 🐳 Docker Deployment

### Build Images
```bash
# Build backend
docker build -t stock-analyzer-backend ./backend

# Build frontend
docker build -t stock-analyzer-frontend ./frontend
```

### Run with Docker Compose
```bash
docker-compose up -d
```

Access:
- Frontend: `http://localhost:3000`
- Backend API: `http://localhost:8000`
- API Docs: `http://localhost:8000/docs`

---

## 🌐 Deploy to moneyboy.tech

### Option 1: AWS EC2 / VPS
1. **Setup Server**
   ```bash
   ssh ubuntu@your-server-ip
   
   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   
   # Install Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

2. **Clone Repository**
   ```bash
   git clone <your-repo-url> /app
   cd /app
   ```

3. **Setup Environment**
   ```bash
   # Backend .env
   cp backend/.env.example backend/.env
   # Edit with your settings
   
   # Frontend .env
   cp frontend/.env.example frontend/.env
   echo REACT_APP_API_URL=https://api.moneyboy.tech >> frontend/.env
   ```

4. **Deploy with Docker Compose**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

### Option 2: Vercel (Frontend) + Railway (Backend)

**Deploy Frontend to Vercel:**
```bash
npm install -g vercel
cd frontend
vercel --env REACT_APP_API_URL=https://api.moneyboy.tech
```

**Deploy Backend to Railway:**
- Connect GitHub repo
- Select `/backend` as root directory
- Set environment variables
- Deploy

### Option 3: Traditional Server

1. **Install Dependencies**
   ```bash
   sudo apt-get update
   sudo apt-get install python3.9 python3-pip nodejs npm nginx
   ```

2. **Setup Backend**
   ```bash
   cd /var/www/stock-analyzer/backend
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Setup Frontend**
   ```bash
   cd /var/www/stock-analyzer/frontend
   npm install
   npm run build
   ```

4. **Configure nginx**
   ```bash
   sudo cp nginx.conf /etc/nginx/sites-available/moneyboy.tech
   sudo ln -s /etc/nginx/sites-available/moneyboy.tech /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

5. **Start Backend (using PM2)**
   ```bash
   npm install -g pm2
   cd /var/www/stock-analyzer/backend
   pm2 start "python main.py" --name stock-analyzer
   pm2 startup
   pm2 save
   ```

---

## 🔐 SSL/TLS Setup

### Using Let's Encrypt (Free)
```bash
# Install Certbot
sudo apt-get install certbot python3-certbot-nginx

# Generate certificate
sudo certbot certonly --nginx -d moneyboy.tech -d www.moneyboy.tech

# Auto-renewal
sudo systemctl enable certbot.timer
```

---

## 📊 API Endpoints

### Analyze Single Chart
```
POST /analyze
Content-Type: multipart/form-data

Request:
file: <image_file>

Response:
{
  "prediction": "UP|DOWN",
  "strength": 75,
  "stopLoss": "98.50",
  "takeProfit": "105.25",
  "patterns": ["Bullish Engulfing", "Hammer"],
  "analysis": "Detailed technical breakdown...",
  "timeframe": "1-hour",
  "keyLevels": {
    "support": [95.00, 90.50],
    "resistance": [105.00, 110.50]
  },
  "riskReward": "1:2.0",
  "tradingSetup": "Entry at market, SL below recent low..."
}
```

### Batch Analysis
```
POST /batch-analyze
Content-Type: multipart/form-data

Request:
files: <multiple_files>

Response:
[
  {"filename": "chart1.png", "analysis": {...}},
  {"filename": "chart2.png", "analysis": {...}}
]
```

### Health Check
```
GET /health

Response:
{
  "status": "healthy",
  "service": "Stock Analysis Bot"
}
```

---

## 🎯 Features

### Candlestick Patterns
- **Reversal**: Hammer, Inverted Hammer, Engulfing, Morning/Evening Star
- **Continuation**: Doji, Spinning Top, Three Methods
- **Indecision**: Long-legged Doji, Harami

### Chart Patterns
- Head & Shoulders, Double/Triple Tops/Bottoms
- Triangles (Ascending, Descending, Symmetrical)
- Flags, Pennants, Wedges
- Cup & Handle, Channels

### Technical Analysis
- Trend identification (Up/Down/Sideways)
- Moving averages (MA20, MA50)
- Support & Resistance levels
- Volume profile analysis
- Risk/Reward ratio calculation

### Trading Features
- Entry signal generation
- Stop loss placement
- Take profit targets
- Confidence scoring (0-100%)
- Position sizing recommendations

---

## 🚀 Optimization Tips

### Performance
1. **Cache pattern recognition results**
   ```python
   from functools import lru_cache
   @lru_cache(maxsize=128)
   def analyze(image_hash):
       ...
   ```

2. **Compress images**
   ```python
   image = Image.open(file)
   image.thumbnail((1024, 1024), Image.Resampling.LANCZOS)
   ```

3. **Use GPU for TensorFlow**
   - Install CUDA & cuDNN
   - TensorFlow will auto-detect

### Scalability
1. **Load balancing**: Use nginx upstream blocks
2. **Database**: Add PostgreSQL for historical analysis
3. **Queue**: Use Celery + Redis for batch processing
4. **Caching**: Redis for frequently accessed patterns

---

## 🧪 Testing

### Backend Tests
```bash
cd backend
pip install pytest
pytest tests/
```

### Frontend Tests
```bash
cd frontend
npm test
```

---

## 📈 Monitoring

### Logs
```bash
# Docker logs
docker logs stock-analyzer-backend
docker logs stock-analyzer-frontend

# PM2 logs
pm2 logs stock-analyzer

# nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

### Health Monitoring
```bash
# Check service status
curl https://api.moneyboy.tech/health
```

---

## 🐛 Troubleshooting

### Backend Issues
- **Import errors**: Verify `pip install -r requirements.txt`
- **Image processing fails**: Check OpenCV installation
- **CORS errors**: Verify origins in main.py

### Frontend Issues
- **API connection fails**: Check REACT_APP_API_URL env variable
- **Styles not loading**: Clear cache, rebuild CSS
- **Image upload fails**: Check file size limits

---

## 📚 Advanced Configuration

### Model Training
To train custom pattern recognition:
1. Collect labeled chart images
2. Preprocess with `data_preprocessing.py`
3. Train with `train_model.py`
4. Deploy model to backend

### Custom Patterns
Add new patterns in `candlestick_analyzer.py`:
```python
def _is_custom_pattern(self, candles: List[Candle]) -> bool:
    # Your pattern logic
    return condition
```

---

## 🔄 Updates & Maintenance

### Update Dependencies
```bash
# Backend
pip install --upgrade -r requirements.txt

# Frontend
npm update
```

### Database Backup
```bash
# If using PostgreSQL
pg_dump stock_db > backup.sql
```

---

## 📞 Support & Resources

- **API Documentation**: https://api.moneyboy.tech/docs
- **Issues**: Create GitHub issues
- **Discussion**: Discord/Slack community
- **Email**: support@moneyboy.tech

---

## 📄 License & Disclaimer

**DISCLAIMER**: This bot is for educational purposes only. Always conduct your own research before trading. Past performance ≠ future results.

---

## 🎓 Next Steps

1. **Train on real data**: Collect historical charts
2. **Backtesting**: Test strategies on historical data
3. **ML enhancement**: Implement deep learning models
4. **Real-time alerts**: Add WebSocket for live signals
5. **Portfolio tracking**: Track trades and performance

---

**Happy Trading! 📊📈**
