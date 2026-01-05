from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
from PIL import Image
import io
import numpy as np
from candlestick_analyzer import CandlestickAnalyzer
from pydantic import BaseModel
from typing import List, Optional
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Stock Chart Analysis Bot",
    description="AI-powered candlestick pattern recognition and technical analysis",
    version="1.0.0"
)

# Configure CORS for moneyboy.tech
origins = [
    "http://localhost:3000",
    "http://localhost:3001",
    "http://localhost:8000",
    "https://moneyboy.tech",
    "https://www.moneyboy.tech",
    "http://moneyboy.tech",
    "http://www.moneyboy.tech"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize analyzer
analyzer = CandlestickAnalyzer()

class AnalysisResponse(BaseModel):
    prediction: str  # "UP" or "DOWN"
    strength: int  # 0-100 confidence percentage
    stopLoss: str  # Price or percentage
    takeProfit: str  # Price or percentage
    patterns: List[str]  # Identified patterns
    analysis: str  # Detailed breakdown
    timeframe: str  # Detected timeframe
    keyLevels: dict  # Support and resistance
    riskReward: str  # Risk/reward ratio
    tradingSetup: str  # Entry, SL, TP details

@app.get("/")
async def root():
    return {
        "message": "Stock Chart Analysis Bot - Ready for analysis",
        "upload_endpoint": "/analyze",
        "version": "1.0.0"
    }

@app.post("/analyze")
async def analyze_chart(file: UploadFile = File(...)):
    """
    Upload a candlestick chart image for analysis.
    Returns comprehensive technical analysis with patterns, predictions, and trading setup.
    """
    try:
        # Read and validate image
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))
        
        # Convert to numpy array
        img_array = np.array(image)
        
        logger.info(f"Processing image: {file.filename}, Shape: {img_array.shape}")
        
        # Analyze chart
        result = analyzer.analyze(img_array)
        
        return JSONResponse(content=result)
    
    except Exception as e:
        logger.error(f"Error analyzing chart: {str(e)}")
        raise HTTPException(status_code=400, detail=f"Error analyzing image: {str(e)}")

@app.post("/batch-analyze")
async def batch_analyze(files: List[UploadFile] = File(...)):
    """
    Analyze multiple chart images in batch.
    """
    results = []
    
    for file in files:
        try:
            contents = await file.read()
            image = Image.open(io.BytesIO(contents))
            img_array = np.array(image)
            result = analyzer.analyze(img_array)
            results.append({
                "filename": file.filename,
                "analysis": result
            })
        except Exception as e:
            results.append({
                "filename": file.filename,
                "error": str(e)
            })
    
    return JSONResponse(content=results)

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "Stock Analysis Bot"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
