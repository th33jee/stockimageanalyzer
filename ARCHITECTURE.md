# Architecture & System Design

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER (Browser)                   │
│  User uploads candlestick chart image via drag-and-drop     │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTPS/WebSocket
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    FRONTEND (React 18)                      │
│  ├─ App.js - Main component                                 │
│  ├─ AnalysisResult.js - Results display                    │
│  ├─ StrengthBar.js - Green/Red confidence bar             │
│  └─ LoadingSpinner.js - Loading animation                 │
│                                                              │
│  Features:                                                   │
│  • Drag-and-drop upload                                     │
│  • Real-time analysis                                       │
│  • Responsive design                                        │
│  • Beautiful gradient UI                                    │
└────────────────────────┬────────────────────────────────────┘
                         │ POST /analyze (multipart/form-data)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    NGINX (Reverse Proxy)                    │
│  ├─ SSL/TLS termination                                     │
│  ├─ Load balancing (if multiple backends)                  │
│  ├─ Static file serving                                     │
│  └─ Security headers                                        │
└────────────────────────┬────────────────────────────────────┘
                         │ HTTP (internal network)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                   BACKEND (FastAPI)                         │
│  ├─ main.py - API endpoints                                 │
│  │   ├─ POST /analyze                                       │
│  │   ├─ POST /batch-analyze                                │
│  │   ├─ GET /health                                         │
│  │   └─ GET /docs                                          │
│  │                                                           │
│  └─ candlestick_analyzer.py - Analysis engine             │
│      ├─ Image Processing                                    │
│      │  └─ OpenCV: Extract candles from image              │
│      │                                                       │
│      ├─ Pattern Recognition                                 │
│      │  ├─ Reversal patterns (20 types)                    │
│      │  ├─ Continuation patterns (5 types)                 │
│      │  └─ Chart patterns (10 types)                       │
│      │                                                       │
│      ├─ Technical Analysis                                  │
│      │  ├─ Trend analysis                                   │
│      │  ├─ Moving averages (MA20, MA50)                    │
│      │  ├─ Support/Resistance levels                       │
│      │  └─ Volume analysis                                  │
│      │                                                       │
│      └─ Trading Setup Generation                            │
│         ├─ Prediction (UP/DOWN)                             │
│         ├─ Confidence scoring (0-100%)                     │
│         ├─ Stop Loss calculation                           │
│         └─ Take Profit calculation                         │
└────────────────────────┬────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
    ┌────────┐     ┌──────────┐     ┌─────────┐
    │ Cache  │     │ Database │     │ Storage │
    │(Redis) │     │(Optional)│     │(S3/etc) │
    └────────┘     └──────────┘     └─────────┘
```

---

## Data Flow

### Single Image Analysis

```
1. User uploads image
   ↓
2. Frontend sends POST /analyze
   ↓
3. Backend receives image
   ↓
4. Image Processing:
   - Read image with Pillow
   - Convert to numpy array
   - Apply OpenCV processing
   - Extract candle data
   ↓
5. Pattern Recognition:
   - Check 35+ patterns
   - Score confidence
   - Identify reliable patterns
   ↓
6. Technical Analysis:
   - Calculate moving averages
   - Find support/resistance
   - Analyze trend
   - Calculate volume
   ↓
7. Prediction Generation:
   - Score UP/DOWN probability
   - Calculate SL/TP levels
   - Risk/Reward ratio
   ↓
8. Response with JSON data
   ↓
9. Frontend displays results:
   - Shows prediction (UP/DOWN)
   - Displays strength bar (green/red)
   - Lists patterns found
   - Shows key levels
   - Detailed analysis
   - Trading setup
   ↓
10. User sees full analysis
```

---

## Component Relationships

```
App.js (Main)
├─ Header (navigation, title)
├─ Main Section
│  ├─ Upload Section (when no analysis)
│  │  ├─ Dropzone (drag-and-drop)
│  │  ├─ Preview (image preview)
│  │  └─ Buttons (Analyze, Clear)
│  │
│  └─ Results Section (when analysis done)
│     ├─ StrengthBar.js
│     │  ├─ Green bar (UP width)
│     │  ├─ Red bar (DOWN width)
│     │  └─ Percentage display
│     │
│     └─ AnalysisResult.js
│        ├─ Results Grid
│        │  ├─ Prediction card
│        │  ├─ SL card
│        │  ├─ TP card
│        │  ├─ Risk/Reward card
│        │  ├─ Price card
│        │  └─ Timeframe card
│        │
│        ├─ Patterns Section
│        │  └─ Pattern badges
│        │
│        ├─ Key Levels Section
│        │  ├─ Support levels
│        │  └─ Resistance levels
│        │
│        ├─ Detailed Analysis
│        │  └─ Text breakdown
│        │
│        └─ Trading Setup
│           └─ Entry/SL/TP instructions
│
└─ Footer (disclaimer, about)
```

---

## Pattern Recognition Engine

```
CandlestickAnalyzer Class
├─ __init__()
│  └─ Initialize pattern database
│
├─ analyze(image)
│  ├─ Extract candles from image
│  ├─ Identify patterns
│  ├─ Analyze trend
│  ├─ Find key levels
│  ├─ Make prediction
│  ├─ Calculate levels
│  └─ Generate response
│
├─ _extract_candles_from_image(image)
│  ├─ Convert to grayscale
│  ├─ Binary threshold
│  ├─ Find contours
│  ├─ Extract OHLC from contours
│  └─ Return candle list
│
├─ _identify_patterns(candles)
│  ├─ Check reversal patterns:
│  │  ├─ Bullish/Bearish Engulfing
│  │  ├─ Hammer/Hanging Man
│  │  ├─ Morning/Evening Star
│  │  └─ Three Soldiers/Crows
│  ├─ Check continuation patterns:
│  │  ├─ Doji
│  │  ├─ Spinning Top
│  │  └─ Three Methods
│  └─ Check chart patterns:
│     ├─ Head & Shoulders
│     ├─ Double/Triple tops/bottoms
│     ├─ Triangles
│     ├─ Flags/Pennants
│     └─ Wedges
│
├─ _analyze_trend(candles)
│  ├─ Calculate moving averages
│  ├─ Determine trend direction
│  ├─ Score trend strength
│  └─ Return trend analysis
│
├─ _find_key_levels(candles)
│  ├─ Find local highs (resistance)
│  ├─ Find local lows (support)
│  └─ Return support/resistance levels
│
├─ _make_prediction(candles, patterns, trend)
│  ├─ Score based on trend (40 pts)
│  ├─ Score based on patterns (40 pts)
│  ├─ Score based on candle (20 pts)
│  ├─ Calculate final score (0-100)
│  └─ Return UP/DOWN + confidence
│
├─ _calculate_levels(candles, prediction)
│  ├─ If UP: SL below low, TP = 2x risk
│  ├─ If DOWN: SL above high, TP = 2x risk
│  └─ Return SL and TP levels
│
└─ _generate_analysis_text(...)
   └─ Format detailed analysis report
```

---

## Database Schema (Optional)

If you add a database for analytics:

```sql
-- Users Table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  username VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Analyses Table
CREATE TABLE analyses (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  image_path VARCHAR(500),
  prediction VARCHAR(10),
  strength INT,
  stop_loss DECIMAL(10,2),
  take_profit DECIMAL(10,2),
  patterns TEXT[], -- Array of patterns
  analysis_text TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_created_at (created_at)
);

-- Trades Table (if tracking real trades)
CREATE TABLE trades (
  id SERIAL PRIMARY KEY,
  analysis_id INT REFERENCES analyses(id),
  entry_price DECIMAL(10,2),
  exit_price DECIMAL(10,2),
  status VARCHAR(20), -- 'open', 'closed', 'stopped'
  pnl DECIMAL(10,2),
  created_at TIMESTAMP,
  closed_at TIMESTAMP
);
```

---

## Deployment Topology

### Single Server Setup (Recommended for Start)
```
Internet
  │
  ▼
┌──────────────────────┐
│  moneyboy.tech       │
│  (DNS points here)   │
└──────────────────────┘
  │
  ▼
┌──────────────────────────────────────┐
│  Ubuntu 20.04 Server                 │
│  (AWS EC2 / DigitalOcean / Linode)   │
│                                      │
│  ┌────────────────────────────────┐ │
│  │ Nginx (Port 80/443)            │ │
│  │ • Reverse proxy                │ │
│  │ • SSL/TLS                      │ │
│  │ • Static files                 │ │
│  └─────┬──────────────────────┬───┘ │
│        │                      │     │
│  ┌─────▼──────┐      ┌────────▼──┐ │
│  │ Frontend   │      │ Backend   │ │
│  │ (Port 3000)│      │ (Port 8000)│ │
│  │ React app  │      │ FastAPI   │ │
│  │ Docker     │      │ Docker    │ │
│  └────────────┘      └───────────┘ │
│                                     │
│  Docker Engine                      │
│  Docker Compose                     │
└─────────────────────────────────────┘
```

### Scalable Setup (For Later)
```
Internet
  │
  ▼
┌──────────────────┐
│  CloudFlare CDN  │
│  Cache/DDoS      │
└────────┬─────────┘
         │
    ┌────┴─────┬──────────┐
    ▼          ▼          ▼
  ┌──────┐ ┌──────┐ ┌──────┐
  │ App  │ │ App  │ │ App  │
  │ 1    │ │ 2    │ │ 3    │
  └──────┘ └──────┘ └──────┘
    │          │          │
    └────┬─────┴──────┬───┘
         │            │
    ┌────▼───┐   ┌────▼───┐
    │  Redis │   │ Database│
    │ Cache  │   │ (RDS)   │
    └────────┘   └─────────┘
```

---

## Security Architecture

```
User Browser
    │
    ▼ HTTPS (TLS 1.3)
    ├─ Certificate validation
    ├─ Encrypted data transmission
    └─ HSTS headers
    
    ▼
Nginx (Reverse Proxy)
    ├─ DDoS protection (rate limiting)
    ├─ Security headers
    │  ├─ X-Frame-Options: SAMEORIGIN
    │  ├─ X-Content-Type-Options: nosniff
    │  ├─ X-XSS-Protection
    │  └─ CSP headers
    ├─ File size limits
    └─ Request logging
    
    ▼
FastAPI Backend
    ├─ CORS validation
    ├─ Input validation
    │  ├─ File type checking
    │  ├─ File size limits
    │  └─ Pattern validation
    ├─ Error handling (no info leaks)
    ├─ Rate limiting
    └─ Logging & monitoring
    
    ▼
Processed Data
    ├─ Temporary storage (cleaned up)
    ├─ No PII in logs
    ├─ No credentials stored
    └─ No sensitive data cached
```

---

## Performance Optimization

```
Image Upload (File)
    ▼
Nginx (Compression: gzip)
    ▼
Backend Receives
    ▼
Resize Image (1024x1024) - Reduce processing
    ▼
Extract Candles (OpenCV) - Cached if possible
    ▼
Pattern Matching (Vectorized NumPy) - Fast
    ▼
Generate Response - JSON (small payload)
    ▼
Nginx (Compression) - gzip to browser
    ▼
Browser Renders
    ▼
User Sees Results (< 5 seconds typically)
```

---

## Monitoring & Logging

```
Backend Logs
├─ API request logs
│  ├─ Timestamp
│  ├─ Method (POST)
│  ├─ Endpoint (/analyze)
│  ├─ Status code
│  └─ Response time
│
├─ Analysis logs
│  ├─ Patterns found
│  ├─ Confidence score
│  └─ Execution time
│
└─ Error logs
   ├─ Exception type
   ├─ Stack trace
   └─ Request details

Frontend Logs
├─ Upload events
├─ API calls
├─ User interactions
└─ Errors

Infrastructure Logs
├─ Nginx access logs
├─ Nginx error logs
├─ Docker container logs
└─ System resource usage
```

---

## Backup & Recovery

```
Data to Backup:
├─ Database (if using)
├─ Uploaded images
├─ Configuration files
└─ SSL certificates

Backup Strategy:
├─ Daily snapshots
├─ Weekly full backups
├─ Monthly archives
└─ Off-site storage

Recovery Procedure:
├─ Restore from backup
├─ Verify integrity
├─ Start services
└─ Health check
```

---

## Technology Stack Justification

| Component | Technology | Why |
|-----------|-----------|-----|
| Backend | FastAPI | Fast, modern, async, auto-docs |
| Frontend | React 18 | Component-based, large ecosystem |
| Image Processing | OpenCV | Best for computer vision |
| Numerical | NumPy | Fast array operations |
| ML | TensorFlow | Extensible for future ML models |
| Web Server | Nginx | Fast, lightweight, stable |
| Containerization | Docker | Portable, isolated, scalable |
| Orchestration | Docker Compose | Simple, perfect for 2-tier |
| SSL | Let's Encrypt | Free, automated, trusted |
| Deployment | Ubuntu Linux | Stable, widely supported |

---

This architecture is **production-ready** and **scalable** for your needs! 🚀
