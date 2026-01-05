import React from 'react';
import './LoadingSpinner.css';

function LoadingSpinner() {
  return (
    <div className="spinner-container">
      <div className="spinner"></div>
      <span className="loading-text">Analyzing...</span>
    </div>
  );
}

export default LoadingSpinner;
