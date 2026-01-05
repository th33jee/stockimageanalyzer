import React, { useState } from 'react';
import { useDropzone } from 'react-dropzone';
import axios from 'axios';
import './App.css';
import AnalysisResult from './components/AnalysisResult';
import StrengthBar from './components/StrengthBar';
import LoadingSpinner from './components/LoadingSpinner';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

function App() {
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [analysis, setAnalysis] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const onDrop = (acceptedFiles) => {
    if (acceptedFiles.length > 0) {
      const selectedFile = acceptedFiles[0];
      setFile(selectedFile);
      setError(null);

      // Create preview
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreview(reader.result);
      };
      reader.readAsDataURL(selectedFile);
    }
  };

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.jpeg', '.jpg', '.png', '.gif', '.webp']
    }
  });

  const analyzeChart = async () => {
    if (!file) {
      setError('Please select an image first');
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const formData = new FormData();
      formData.append('file', file);

      const response = await axios.post(`${API_BASE_URL}/analyze`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
        timeout: 30000
      });

      setAnalysis(response.data);
    } catch (err) {
      console.error('Analysis error:', err);
      setError(err.response?.data?.detail || 'Failed to analyze chart. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const resetAnalysis = () => {
    setFile(null);
    setPreview(null);
    setAnalysis(null);
    setError(null);
  };

  return (
    <div className="App">
      <header className="app-header">
        <h1>📊 Stock Chart Analysis Bot</h1>
        <p>AI-Powered Candlestick Pattern Recognition & Technical Analysis</p>
      </header>

      <main className="app-main">
        {!analysis ? (
          <div className="upload-section">
            <div {...getRootProps()} className={`dropzone ${isDragActive ? 'active' : ''}`}>
              <input {...getInputProps()} />
              {isDragActive ? (
                <p>Drop the chart image here...</p>
              ) : (
                <div>
                  <p className="dropzone-title">📈 Drop Your Chart Here</p>
                  <p className="dropzone-subtitle">or click to select a candlestick chart image</p>
                  <p className="dropzone-formats">Supports: JPG, PNG, GIF, WebP</p>
                </div>
              )}
            </div>

            {preview && (
              <div className="preview-section">
                <img src={preview} alt="Chart preview" className="preview-image" />
                <div className="button-group">
                  <button 
                    className="btn btn-primary" 
                    onClick={analyzeChart}
                    disabled={loading}
                  >
                    {loading ? <LoadingSpinner /> : '🔍 Analyze Chart'}
                  </button>
                  <button 
                    className="btn btn-secondary" 
                    onClick={resetAnalysis}
                    disabled={loading}
                  >
                    ↺ Clear
                  </button>
                </div>
              </div>
            )}

            {error && <div className="error-message">{error}</div>}
          </div>
        ) : (
          <div className="results-section">
            <button 
              className="btn btn-secondary back-btn" 
              onClick={resetAnalysis}
            >
              ← Back to Upload
            </button>

            {/* Chart Image with Results */}
            <div className="chart-analysis-container">
              <div className="chart-wrapper">
                <img src={preview} alt="Analyzed chart" className="result-image" />
              </div>

              {/* Strength Bar */}
              <StrengthBar 
                prediction={analysis.prediction}
                strength={analysis.strength}
              />

              {/* Main Results */}
              <AnalysisResult analysis={analysis} />
            </div>
          </div>
        )}
      </main>

      <footer className="app-footer">
        <p>Moneyboy.tech - Advanced Stock Technical Analysis</p>
        <p>Disclaimer: For educational purposes. Always conduct your own research.</p>
      </footer>
    </div>
  );
}

export default App;
