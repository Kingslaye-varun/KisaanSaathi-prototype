"""
Simplified Training Script for Hybrid Crop Yield Model
Uses preprocessed data from preprocessing.py
"""

import numpy as np
import pandas as pd
import joblib
import os
from sklearn.ensemble import RandomForestRegressor
from xgboost import XGBRegressor
from lightgbm import LGBMRegressor
from sklearn.linear_model import RidgeCV
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score
import tensorflow as tf
from tensorflow.keras.models import Model
from tensorflow.keras.layers import (Input, LSTM, Bidirectional, Conv1D, 
                                     Dense, Dropout, Attention, 
                                     GlobalAveragePooling1D)
from tensorflow.keras.callbacks import EarlyStopping, ReduceLROnPlateau
import warnings
warnings.filterwarnings('ignore')

print("=" * 60)
print("HYBRID CROP YIELD MODEL - TRAINING")
print("=" * 60)

# ============================================================
# STEP 1: LOAD PREPROCESSED DATA
# ============================================================

print("\n📂 Loading preprocessed data...")
data_dir = 'preprocessed_data'

try:
    X_static_train = np.load(f'{data_dir}/X_static_train.npy')
    X_static_val = np.load(f'{data_dir}/X_static_val.npy')
    X_static_test = np.load(f'{data_dir}/X_static_test.npy')
    
    X_temporal_train = np.load(f'{data_dir}/X_temporal_train.npy')
    X_temporal_val = np.load(f'{data_dir}/X_temporal_val.npy')
    X_temporal_test = np.load(f'{data_dir}/X_temporal_test.npy')
    
    y_train = np.load(f'{data_dir}/y_train.npy')
    y_val = np.load(f'{data_dir}/y_val.npy')
    y_test = np.load(f'{data_dir}/y_test.npy')
    
    feature_names = joblib.load(f'{data_dir}/feature_names.pkl')
    
    print(f"✓ Static features: {X_static_train.shape}")
    print(f"✓ Temporal sequences: {X_temporal_train.shape}")
    print(f"✓ Training samples: {len(y_train)}")
    print(f"✓ Validation samples: {len(y_val)}")
    print(f"✓ Test samples: {len(y_test)}")
    
except FileNotFoundError as e:
    print(f"❌ Error: Preprocessed data not found!")
    print(f"   Please run preprocessing.py first")
    exit(1)

# ============================================================
# STEP 2: BUILD AND TRAIN STATIC MODELS
# ============================================================

print("\n" + "=" * 60)
print("🌾 STAGE 1: Training Static Models (RF, XGB, LightGBM)")
print("=" * 60)

static_models = {}
static_train_preds = np.zeros((len(y_train), 3))
static_val_preds = np.zeros((len(y_val), 3))
static_test_preds = np.zeros((len(y_test), 3))

# 1. Random Forest
print("\n1️⃣ Training Random Forest...")
rf_model = RandomForestRegressor(
    n_estimators=200,
    max_depth=15,
    min_samples_split=5,
    n_jobs=-1,
    random_state=42,
    verbose=0
)
rf_model.fit(X_static_train, y_train)
static_train_preds[:, 0] = rf_model.predict(X_static_train)
static_val_preds[:, 0] = rf_model.predict(X_static_val)
static_test_preds[:, 0] = rf_model.predict(X_static_test)
rf_score = r2_score(y_val, static_val_preds[:, 0])
print(f"   ✓ Validation R²: {rf_score:.4f}")
static_models['rf'] = rf_model

# 2. XGBoost
print("\n2️⃣ Training XGBoost...")
xgb_model = XGBRegressor(
    n_estimators=300,
    max_depth=8,
    learning_rate=0.05,
    subsample=0.8,
    colsample_bytree=0.8,
    objective='reg:squarederror',
    n_jobs=-1,
    random_state=42,
    verbosity=0
)
xgb_model.fit(X_static_train, y_train)
static_train_preds[:, 1] = xgb_model.predict(X_static_train)
static_val_preds[:, 1] = xgb_model.predict(X_static_val)
static_test_preds[:, 1] = xgb_model.predict(X_static_test)
xgb_score = r2_score(y_val, static_val_preds[:, 1])
print(f"   ✓ Validation R²: {xgb_score:.4f}")
static_models['xgb'] = xgb_model

# 3. LightGBM
print("\n3️⃣ Training LightGBM...")
lgb_model = LGBMRegressor(
    n_estimators=300,
    max_depth=12,
    learning_rate=0.05,
    num_leaves=31,
    objective='regression',
    n_jobs=-1,
    random_state=42,
    verbose=-1
)
lgb_model.fit(X_static_train, y_train)
static_train_preds[:, 2] = lgb_model.predict(X_static_train)
static_val_preds[:, 2] = lgb_model.predict(X_static_val)
static_test_preds[:, 2] = lgb_model.predict(X_static_test)
lgb_score = r2_score(y_val, static_val_preds[:, 2])
print(f"   ✓ Validation R²: {lgb_score:.4f}")
static_models['lgb'] = lgb_model

# ============================================================
# STEP 3: BUILD AND TRAIN TEMPORAL MODEL (CNN-LSTM)
# ============================================================

print("\n" + "=" * 60)
print("🧠 STAGE 2: Training Temporal Model (CNN-LSTM)")
print("=" * 60)

def build_cnn_lstm_model(temporal_shape):
    """Build CNN-LSTM model for temporal weather patterns"""
    inputs = Input(shape=temporal_shape, name='temporal_input')
    
    # 1D CNN for local pattern extraction
    x = Conv1D(filters=64, kernel_size=3, activation='relu', padding='same')(inputs)
    x = Conv1D(filters=32, kernel_size=3, activation='relu', padding='same')(x)
    
    # Bidirectional LSTM
    x = Bidirectional(LSTM(64, return_sequences=True))(x)
    x = Dropout(0.3)(x)
    
    # Attention mechanism
    attention = Attention()([x, x])
    
    # Second LSTM
    x = LSTM(32)(attention)
    x = Dropout(0.2)(x)
    
    # Dense layers
    x = Dense(32, activation='relu')(x)
    x = Dropout(0.2)(x)
    outputs = Dense(1)(x)
    
    model = Model(inputs, outputs, name='CNN_LSTM')
    return model

print("\n🏗️ Building model architecture...")
temporal_model = build_cnn_lstm_model(X_temporal_train.shape[1:])
temporal_model.compile(
    optimizer='adam',
    loss='mse',
    metrics=['mae']
)

print(f"   Model parameters: {temporal_model.count_params():,}")

print("\n🎯 Training CNN-LSTM...")
callbacks = [
    EarlyStopping(
        monitor='val_loss',
        patience=15,
        restore_best_weights=True,
        verbose=1
    ),
    ReduceLROnPlateau(
        monitor='val_loss',
        factor=0.5,
        patience=5,
        verbose=1
    )
]

history = temporal_model.fit(
    X_temporal_train, y_train,
    validation_data=(X_temporal_val, y_val),
    epochs=100,
    batch_size=32,
    callbacks=callbacks,
    verbose=1
)

# Get predictions
temporal_train_preds = temporal_model.predict(X_temporal_train, verbose=0).flatten()
temporal_val_preds = temporal_model.predict(X_temporal_val, verbose=0).flatten()
temporal_test_preds = temporal_model.predict(X_temporal_test, verbose=0).flatten()

lstm_score = r2_score(y_val, temporal_val_preds)
print(f"\n   ✓ Validation R²: {lstm_score:.4f}")

# ============================================================
# STEP 4: TRAIN META-LEARNER (STACKING)
# ============================================================

print("\n" + "=" * 60)
print("🎯 STAGE 3: Training Meta-Learner (Stacking)")
print("=" * 60)

# Combine all base model predictions
meta_train = np.column_stack([
    static_train_preds,  # RF, XGB, LGB
    temporal_train_preds  # LSTM
])

meta_val = np.column_stack([
    static_val_preds,
    temporal_val_preds
])

meta_test = np.column_stack([
    static_test_preds,
    temporal_test_preds
])

print(f"\n📊 Meta-features shape: {meta_train.shape}")
print("   Columns: [RF, XGB, LGB, LSTM]")

# Train Ridge regression as meta-learner
print("\n🔧 Training Ridge meta-learner...")
meta_learner = RidgeCV(alphas=[0.01, 0.1, 1.0, 10.0, 100.0])
meta_learner.fit(meta_train, y_train)

print(f"   ✓ Best alpha: {meta_learner.alpha_}")

# ============================================================
# STEP 5: EVALUATE FINAL MODEL
# ============================================================

print("\n" + "=" * 60)
print("📊 FINAL MODEL EVALUATION")
print("=" * 60)

# Final predictions
final_train_pred = meta_learner.predict(meta_train)
final_val_pred = meta_learner.predict(meta_val)
final_test_pred = meta_learner.predict(meta_test)

def evaluate_predictions(y_true, y_pred, dataset_name):
    """Calculate and display metrics"""
    mse = mean_squared_error(y_true, y_pred)
    rmse = np.sqrt(mse)
    mae = mean_absolute_error(y_true, y_pred)
    r2 = r2_score(y_true, y_pred)
    
    print(f"\n{dataset_name} Set:")
    print(f"  RMSE: {rmse:.4f}")
    print(f"  MAE:  {mae:.4f}")
    print(f"  R²:   {r2:.4f}")
    
    return {'rmse': rmse, 'mae': mae, 'r2': r2}

train_metrics = evaluate_predictions(y_train, final_train_pred, "Training")
val_metrics = evaluate_predictions(y_val, final_val_pred, "Validation")
test_metrics = evaluate_predictions(y_test, final_test_pred, "Test")

# ============================================================
# STEP 6: FEATURE IMPORTANCE
# ============================================================

print("\n" + "=" * 60)
print("🔍 FEATURE IMPORTANCE (Random Forest)")
print("=" * 60)

# Get feature importance from RF
importances = rf_model.feature_importances_
indices = np.argsort(importances)[-10:][::-1]  # Top 10

print("\nTop 10 Most Important Features:")
for i, idx in enumerate(indices, 1):
    print(f"  {i}. {feature_names[idx]}: {importances[idx]:.4f}")

# ============================================================
# STEP 7: SAVE MODELS
# ============================================================

print("\n" + "=" * 60)
print("💾 SAVING MODELS")
print("=" * 60)

models_dir = 'trained_models'
os.makedirs(models_dir, exist_ok=True)

# Save all models
print("\nSaving models...")
joblib.dump(static_models['rf'], f'{models_dir}/rf_model.pkl')
print("  ✓ Random Forest saved")

joblib.dump(static_models['xgb'], f'{models_dir}/xgb_model.pkl')
print("  ✓ XGBoost saved")

joblib.dump(static_models['lgb'], f'{models_dir}/lgb_model.pkl')
print("  ✓ LightGBM saved")

temporal_model.save(f'{models_dir}/lstm_model.h5')
print("  ✓ CNN-LSTM saved")

joblib.dump(meta_learner, f'{models_dir}/meta_learner.pkl')
print("  ✓ Meta-learner saved")

# Save feature names
joblib.dump(feature_names, f'{models_dir}/feature_names.pkl')
print("  ✓ Feature names saved")

# Save metrics
metrics = {
    'train': train_metrics,
    'val': val_metrics,
    'test': test_metrics,
    'base_models': {
        'rf': rf_score,
        'xgb': xgb_score,
        'lgb': lgb_score,
        'lstm': lstm_score
    }
}
joblib.dump(metrics, f'{models_dir}/metrics.pkl')
print("  ✓ Metrics saved")

# ============================================================
# SUMMARY
# ============================================================

print("\n" + "=" * 60)
print("✅ TRAINING COMPLETE!")
print("=" * 60)

print(f"\n📈 Final Test Performance:")
print(f"   RMSE: {test_metrics['rmse']:.4f}")
print(f"   MAE:  {test_metrics['mae']:.4f}")
print(f"   R²:   {test_metrics['r2']:.4f}")

print(f"\n📁 Models saved to: {models_dir}/")
print(f"   • rf_model.pkl")
print(f"   • xgb_model.pkl")
print(f"   • lgb_model.pkl")
print(f"   • lstm_model.h5")
print(f"   • meta_learner.pkl")
print(f"   • feature_names.pkl")
print(f"   • metrics.pkl")

print("\n🎯 Next Steps:")
print("   1. Run predict.py to make predictions")
print("   2. Use the trained models in your Flask API")
print("   3. Visualize results with visualize.py")

print("\n" + "=" * 60)
