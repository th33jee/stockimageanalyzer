import React from 'react';
import '../App.css';

function AnalysisResult({ analysis }) {
  return (
    <div className="analysis-results">
      <div className="results-grid">
        {/* Prediction Card */}
        <div className="result-card prediction-card">
          <h3>Prediction</h3>
          <div className={`prediction-value ${analysis.prediction.toLowerCase()}`}>
            {analysis.prediction === 'UP' ? '📈 BULLISH' : '📉 BEARISH'}
          </div>
        </div>

        {/* Stop Loss & Take Profit */}
        <div className="result-card">
          <h3>Stop Loss</h3>
          <p className="value">${analysis.stopLoss}</p>
        </div>

        <div className="result-card">
          <h3>Take Profit</h3>
          <p className="value">${analysis.takeProfit}</p>
        </div>

        {/* Risk/Reward */}
        <div className="result-card">
          <h3>Risk/Reward</h3>
          <p className="value">{analysis.riskReward}</p>
        </div>

        {/* Current Price */}
        <div className="result-card">
          <h3>Current Price</h3>
          <p className="value">${analysis.currentPrice?.toFixed(2)}</p>
        </div>

        {/* Timeframe */}
        <div className="result-card">
          <h3>Timeframe</h3>
          <p className="value">{analysis.timeframe}</p>
        </div>
      </div>

      {/* Patterns Section */}
      <div className="patterns-section">
        <h3>📍 Candlestick Patterns Identified</h3>
        <div className="patterns-list">
          {analysis.patterns && analysis.patterns.length > 0 ? (
            analysis.patterns.map((pattern, idx) => (
              <span key={idx} className="pattern-badge">{pattern}</span>
            ))
          ) : (
            <span className="pattern-badge">No specific patterns detected</span>
          )}
        </div>
      </div>

      {/* Key Levels */}
      <div className="key-levels-section">
        <div className="levels-column">
          <h4>💪 Resistance Levels</h4>
          {analysis.keyLevels.resistance && analysis.keyLevels.resistance.length > 0 ? (
            <ul>
              {analysis.keyLevels.resistance.map((level, idx) => (
                <li key={idx}>${level}</li>
              ))}
            </ul>
          ) : (
            <p>No resistance levels detected</p>
          )}
        </div>

        <div className="levels-column">
          <h4>🛑 Support Levels</h4>
          {analysis.keyLevels.support && analysis.keyLevels.support.length > 0 ? (
            <ul>
              {analysis.keyLevels.support.map((level, idx) => (
                <li key={idx}>${level}</li>
              ))}
            </ul>
          ) : (
            <p>No support levels detected</p>
          )}
        </div>
      </div>

      {/* Detailed Analysis */}
      <div className="detailed-analysis">
        <h3>📋 Detailed Technical Analysis</h3>
        <div className="analysis-text">
          {analysis.analysis?.split('\n').map((line, idx) => (
            <p key={idx}>{line}</p>
          ))}
        </div>
      </div>

      {/* Trading Setup */}
      <div className="trading-setup">
        <h3>🎯 Trading Setup Instructions</h3>
        <div className="setup-text">
          {analysis.tradingSetup?.split('\n').map((line, idx) => (
            <p key={idx}>{line}</p>
          ))}
        </div>
      </div>
    </div>
  );
}

export default AnalysisResult;
