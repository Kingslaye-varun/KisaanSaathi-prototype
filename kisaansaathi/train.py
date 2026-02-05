"""
Inference Script for Hybrid Crop Yield Model

Usage:
    python train.py --models_dir flask-model-server --input crop_yield.csv --output predictions.csv
"""

import numpy as np
import pandas as pd
import argparse
import joblib
import os
import tensorflow as tf
from preproccessing import CompleteIndianCropPreprocessor


def load_models(models_dir):
    """Load all trained models"""
    print(f"Loading models from {models_dir}/...")
    
    models = {
        'rf': joblib.load(f'{models_dir}/rf_model.pkl') if os.path.exists(f'{models_dir}/rf_model.pkl') else None,
        'xgb': joblib.load(f'{models_dir}/xgb_model.pkl') if os.path.exists(f'{models_dir}/xgb_model.pkl') else None,
        'lgb': joblib.load(f'{models_dir}/lgb_model.pkl') if os.path.exists(f'{models_dir}/lgb_model.pkl') else None,
        'cnn_lstm': tf.keras.models.load_model(f'{models_dir}/best_model.keras') if os.path.exists(f'{models_dir}/best_model.keras') else None,
        'meta': joblib.load(f'{models_dir}/meta_learner.pkl') if os.path.exists(f'{models_dir}/meta_learner.pkl') else None,
        'scaler': joblib.load('preprocessed_data/scaler_static.pkl'),
        'encoders': joblib.load('preprocessed_data/label_encoders.pkl'),
        'feature_names': joblib.load('preprocessed_data/feature_names.pkl')
    }
    
    print("  ✓ All models loaded")
    return models


def predict_yield(models, X_static, X_temporal):
    """Generate predictions using full hybrid pipeline"""
    # Scale static features
    X_static_scaled = models['scaler'].transform(X_static)
    
    predictions_list = []
    ind_preds = {}
    
    # Static predictions (if models exist)
    if models['rf'] is not None:
        rf_pred = models['rf'].predict(X_static_scaled)
        predictions_list.append(rf_pred)
        ind_preds['RandomForest'] = np.expm1(rf_pred)
    
    if models['xgb'] is not None:
        xgb_pred = models['xgb'].predict(X_static_scaled)
        predictions_list.append(xgb_pred)
        ind_preds['XGBoost'] = np.expm1(xgb_pred)
    
    if models['lgb'] is not None:
        lgb_pred = models['lgb'].predict(X_static_scaled)
        predictions_list.append(lgb_pred)
        ind_preds['LightGBM'] = np.expm1(lgb_pred)
    
    # Temporal prediction (if model exists)
    if models['cnn_lstm'] is not None:
        lstm_pred = models['cnn_lstm'].predict(X_temporal, verbose=0).flatten()
        predictions_list.append(lstm_pred)
        ind_preds['CNN_LSTM'] = np.expm1(lstm_pred)
    
    # Meta-learning or averaging
    if models['meta'] is not None and len(predictions_list) >= 4:
        X_meta = np.column_stack(predictions_list)
        final_pred_log = models['meta'].predict(X_meta)
    elif len(predictions_list) > 0:
        # Simple averaging if meta-learner doesn't exist
        final_pred_log = np.mean(predictions_list, axis=0)
    else:
        raise ValueError("No models available for prediction")
    
    # Convert from log scale
    final_pred = np.expm1(final_pred_log)
    
    return final_pred, ind_preds


def main():
    parser = argparse.ArgumentParser(description='Predict Crop Yield')
    parser.add_argument('--models_dir', type=str, default='flask-model-server',
                       help='Directory with trained models')
    parser.add_argument('--input', type=str, required=True,
                       help='Input CSV with crop data')
    parser.add_argument('--output', type=str, default='predictions.csv',
                       help='Output CSV file')
    args = parser.parse_args()
    
    # Load models
    models = load_models(args.models_dir)
    
    # Load and preprocess new data
    print(f"\nLoading input data from {args.input}...")
    df = pd.read_csv(args.input)
    
    # Preprocess (reuse preprocessor)
    preprocessor = CompleteIndianCropPreprocessor()
    preprocessor.label_encoders = models['encoders']
    preprocessor.scaler_static = models['scaler']
    
    # Process data
    df_clean = preprocessor.clean_data(df)
    df_eng = preprocessor.engineer_features(df_clean)
    df_enc = preprocessor.encode_categorical(df_eng)
    X_temporal = preprocessor.generate_temporal_sequences(df_enc)
    X_static, _ = preprocessor.prepare_static_features(df_enc)
    
    # Predict
    print("\nGenerating predictions...")
    predictions, ind_preds = predict_yield(models, X_static, X_temporal)
    
    # Save results
    result_dict = {
        'Crop': df_enc['Crop'],
        'State': df_enc['State'],
        'Season': df_enc['Season'],
        'Predicted_Yield': predictions
    }
    
    # Add individual predictions if available
    for model_name, preds in ind_preds.items():
        result_dict[f'{model_name}_Pred'] = preds
    
    results = pd.DataFrame(result_dict)
    
    results.to_csv(args.output, index=False)
    print(f"\n✓ Predictions saved to {args.output}")
    print(f"\nSample predictions:")
    print(results.head(10))


if __name__ == '__main__':
    main()
