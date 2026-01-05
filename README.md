# Stock Chart Analysis Bot - Desktop Application

<div align="center">

# 📊 Stock Analysis Bot

**AI-Powered Candlestick Pattern Recognition & Technical Analysis**  
**Now Available as a Desktop Application! 🖥️**

[![Python 3.9+](https://img.shields.io/badge/Python-3.9%2B-blue)](https://www.python.org/)
[![React 18](https://img.shields.io/badge/React-18-blue)](https://react.dev/)
[![FastAPI](https://img.shields.io/badge/FastAPI-Latest-green)](https://fastapi.tiangolo.com/)
[![Electron](https://img.shields.io/badge/Electron-39-blue)](https://www.electronjs.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

[Quick Start](#quick-start) • [Features](#-features) • [How to Use](#-how-to-use) • [Troubleshooting](#-troubleshooting)

</div>

---

## 🎯 Overview

Stock Analysis Bot is now a **standalone desktop application** that analyzes candlestick chart images and provides:

- **Prediction**: UP or DOWN with confidence level (0-100%)
- **Trading Setup**: Entry points, Stop Loss, Take Profit targets
- **Pattern Recognition**: Identifies 28+ candlestick patterns
- **Technical Analysis**: Trend analysis, support/resistance levels, RSI analysis
- **Local Processing**: All analysis happens on your computer - no cloud uploads
- **Simple Interface**: Drag-and-drop chart upload with instant results

### Perfect For:
- Traders learning technical analysis
- Quick chart pattern identification
- Backtesting chart patterns
- Educational trading platform

---

## ✨ Features

### 📈 Candlestick Pattern Recognition

**Reversal Patterns**
- Hammer, Inverted Hammer
- Bullish/Bearish Engulfing
- Morning Star, Evening Star
- Three White Soldiers, Three Black Crows

**Continuation Patterns**
- Doji (all types)
- Spinning Top
- Rising/Falling Three Methods

**Chart Patterns**
- Head & Shoulders (and inverse)
- Double/Triple Tops & Bottoms
- Ascending/Descending/Symmetrical Triangles
- Flags, Pennants, Wedges
- Cup & Handle, Channels

### 🎯 Technical Analysis
- Trend identification (Up/Down/Sideways)
- Moving averages (MA20, MA50)
- Support & Resistance level detection
- Volume profile analysis
- Risk/Reward ratio calculation
- Confidence scoring (0-100%)

### 🎨 User Interface
- Drag-and-drop image upload
- Beautiful dark gradient theme
- Real-time analysis processing
- Visual strength bar indicator
- Responsive design (mobile-friendly)
- Detailed analysis breakdown

### 🔧 Developer Features
- RESTful API with automatic documentation
- Docker support
- CORS enabled for easy integration
- Batch analysis capability
- Custom pattern extension support

---

## 🚀 Quick Start

### Prerequisites
- Python 3.9+
- Node.js 16+
- Docker (optional)

### Local Development

#### Option 1: Automatic Setup

**Windows:**
```bash
quickstart.bat
```

**Mac/Linux:**
```bash
bash quickstart.sh
```

#### Option 2: Manual Setup

**Backend:**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate     # Windows
pip install -r requirements.txt
python main.py
```

**Frontend (new terminal):**
```bash
cd frontend
npm install
npm start
```

### Docker Deployment

```bash
docker-compose up
```

Access the app at `http://localhost:3000`

---

## 📡 API

### Analyze Chart
```
POST /analyze
Content-Type: multipart/form-data

Request:
{
  "file": <image_file>
}

Response:
{
  "prediction": "UP",
  "strength": 78,
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
  "tradingSetup": "Entry at market price...",
  "currentPrice": 100.25
}
```

### Batch Analysis
```
POST /batch-analyze
Content-Type: multipart/form-data

Request:
{
  "files": [<image1>, <image2>, ...]
}

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

**Full API Documentation**: `http://localhost:8000/docs`

---

## 🌐 Deployment

### Deploy to moneyboy.tech

#### Option 1: Docker (Recommended)
```bash
docker-compose -f docker-compose.prod.yml up -d
```

#### Option 2: VPS/EC2
See [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions

#### Option 3: Cloud Platforms
- **Frontend**: Vercel, Netlify
- **Backend**: Railway, Heroku, AWS Lambda

### SSL/TLS
```bash
# Using Let's Encrypt
sudo certbot certonly --nginx -d moneyboy.tech -d www.moneyboy.tech
```

---

## 📚 Project Structure

```
stockimageanalyzer/
├── backend/
│   ├── main.py                 # FastAPI application
│   ├── candlestick_analyzer.py # Analysis engine
│   ├── requirements.txt        # Python dependencies
│   ├── Dockerfile
│   └── .env.example
├── frontend/
│   ├── src/
│   │   ├── App.js             # Main component
│   │   ├── App.css            # Styles
│   │   ├── components/        # React components
│   │   ├── index.js
│   │   └── index.css
│   ├── package.json
│   ├── Dockerfile
│   └── .env.example
├── docker-compose.yml
├── nginx.conf
└── SETUP_GUIDE.md
```

---

## 🔧 Configuration

### Backend Environment Variables

```env
# API Configuration
PYTHONUNBUFFERED=1
API_HOST=0.0.0.0
API_PORT=8000
DEBUG=False

# CORS Origins
ALLOWED_ORIGINS=https://moneyboy.tech,https://www.moneyboy.tech

# Security
SECRET_KEY=your_secret_key_here
```

### Frontend Environment Variables

```env
# API URL
REACT_APP_API_URL=https://api.moneyboy.tech
REACT_APP_ENV=production
```

---

## 🎓 How It Works

### Analysis Pipeline

1. **Image Upload** → User uploads candlestick chart
2. **Image Processing** → OpenCV extracts candle data
3. **Pattern Recognition** → AI identifies patterns
4. **Technical Analysis** → Calculates indicators
5. **Prediction** → Generates UP/DOWN signal with confidence
6. **Trading Setup** → Calculates SL, TP, risk/reward
7. **Visualization** → Displays results with strength bar

### Pattern Detection Algorithm

```
For each candle group:
├─ Check reversal patterns (Hammer, Engulfing, etc.)
├─ Check continuation patterns (Doji, Spinning Top, etc.)
├─ Check chart patterns (Head & Shoulders, Triangles, etc.)
└─ Score confidence based on:
   ├─ Pattern type reliability
   ├─ Trend alignment
   ├─ Volume confirmation
   └─ Recent candle behavior
```

---

## 📊 Analysis Metrics

### Confidence Scoring (0-100%)
- **0-25%**: Very Weak / No Clear Pattern
- **26-50%**: Weak / Indecision
- **51-75%**: Moderate / Possible Setup
- **76-100%**: Strong / High Probability Setup

### Risk/Reward Ratio
- Minimum: 1:1.5 (acceptable)
- Optimal: 1:2.0 - 1:3.0 (good)
- Excellent: 1:3.0+ (excellent)

---

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest tests/
```

### Frontend Tests
```bash
cd frontend
npm test
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| **Port already in use** | Change port in `.env` or kill existing process |
| **CORS errors** | Update `ALLOWED_ORIGINS` in backend `.env` |
| **Image upload fails** | Check file size limits and image format |
| **API connection error** | Verify `REACT_APP_API_URL` in frontend `.env` |
| **Pattern detection inaccurate** | Consider training on real market data |

See [SETUP_GUIDE.md](SETUP_GUIDE.md) for more troubleshooting.

---

## 📈 Performance Tips

### For Better Accuracy
1. Use clear, high-quality chart images
2. Include sufficient historical candles (20+)
3. Ensure proper candlestick formation
4. Verify trend context

### For Speed
1. Use GPU support (CUDA/cuDNN)
2. Cache pattern recognition results
3. Implement image compression
4. Use Redis for caching

---

## 🛣️ Roadmap

- [ ] Real-time chart analysis via WebSocket
- [ ] Historical backtesting engine
- [ ] Custom pattern training
- [ ] Machine learning model refinement
- [ ] Multi-timeframe analysis
- [ ] Trade logging and performance tracking
- [ ] Mobile app (React Native)
- [ ] Trading bot integration

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

**FOR EDUCATIONAL PURPOSES ONLY**

This bot is designed for learning technical analysis and pattern recognition. Always:
- Conduct thorough research before trading
- Never risk more than 1-2% per trade
- Verify analysis with multiple indicators
- Understand that past performance ≠ future results
- Consult a financial advisor before trading with real money

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourrepo/issues)
- **Email**: support@moneyboy.tech
- **Documentation**: [SETUP_GUIDE.md](SETUP_GUIDE.md)

---

## 🙌 Acknowledgments

- Built with [FastAPI](https://fastapi.tiangolo.com/) and [React](https://react.dev/)
- Pattern recognition inspired by technical analysis textbooks
- Community feedback and contributions

---

<div align="center">

**Built with ❤️ for traders and developers**

⭐ If you find this helpful, please give it a star!

</div>
