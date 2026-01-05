import React from 'react';
import './StrengthBar.css';

function StrengthBar({ prediction, strength }) {
  const isUp = prediction === 'UP';
  const greenWidth = isUp ? strength : 100 - strength;
  const redWidth = isUp ? 100 - strength : strength;

  return (
    <div className="strength-bar-container">
      <div className="strength-bar">
        {/* Green side (Bullish) */}
        <div 
          className="strength-side green"
          style={{ width: `${greenWidth}%` }}
        >
          {greenWidth > 15 && <span className="strength-label">UP</span>}
        </div>

        {/* Middle divider */}
        <div className="strength-divider"></div>

        {/* Red side (Bearish) */}
        <div 
          className="strength-side red"
          style={{ width: `${redWidth}%` }}
        >
          {redWidth > 15 && <span className="strength-label">DOWN</span>}
        </div>
      </div>

      {/* Strength percentage */}
      <div className="strength-percentage">
        <span className="percentage-value">{strength}%</span>
        <span className="confidence-label">Confidence: {strength > 75 ? 'Strong' : strength > 50 ? 'Moderate' : 'Weak'}</span>
      </div>
    </div>
  );
}

export default StrengthBar;
