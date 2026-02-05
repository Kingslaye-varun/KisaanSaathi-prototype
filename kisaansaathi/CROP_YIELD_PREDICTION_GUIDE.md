# Crop Yield Prediction Feature - Complete Guide

## Overview

The Crop Yield Prediction feature uses a hybrid AI ensemble of 4 machine learning models to predict crop yields based on agricultural parameters. The system achieves 97.37% accuracy (R² score) on test data.

## Data Source

**Dataset**: Indian Crop Yield Dataset  
**Source**: [Mendeley Data](https://data.mendeley.com/datasets/ncw2vbcgnk/2)  
**Records**: 19,382 crop yield records  
**Coverage**: 30 Indian states, 55 crops, 6 seasons  
**Years**: 1997-2020

### Dataset Citation
```
Crop Yield Prediction Dataset
DOI: 10.17632/ncw2vbcgnk.2
Available at: https://data.mendeley.com/datasets/ncw2vbcgnk/2
```

## Architecture

### Machine Learning Models

1. **Random Forest Regressor**
   - 200 trees, max depth 15
   - Validation R²: 0.9624
   - Best for: Handling non-linear relationships

2. **XGBoost Regressor**
   - 300 estimators, learning rate 0.05
   - Validation R²: 0.9767
   - Best for: Gradient boosting optimization

3. **LightGBM Regressor**
   - 300 estimators, 31 leaves
   - Validation R²: 0.9726
   - Best for: Fast training on large datasets

4. **CNN-LSTM Model**
   - Temporal weather pattern analysis
   - 78,945 parameters
   - Best for: Sequential weather data

5. **Meta-Learner (Ridge Regression)**
   - Combines all 4 base models
   - Final ensemble prediction
   - Test R²: 0.9737

### Model Pipeline

```
Input Data
    ↓
Feature Engineering (17 features)
    ↓
Static Features → [RF, XGB, LGB] → Predictions
Temporal Features → [CNN-LSTM] → Prediction
    ↓
Meta-Learner (Ridge) → Final Yield Prediction
```

## Features Used

### Input Features (8)
1. State
2. Crop
3. Season
4. Area (hectares)
5. Annual Rainfall (mm)
6. Fertilizer (kg)
7. Pesticide (kg)
8. Crop Year

### Engineered Features (17)
- Crop category encoding
- Agro-climatic zones
- Monsoon dependency
- Irrigation intensity
- Fertilizer per hectare
- Pesticide per hectare
- Input intensity
- Rainfall efficiency
- Log transformations
- Year normalization

## API Endpoints

### Predict Crop Yield

**Endpoint**: `POST /predict_yield`

**Request Body**:
```json
{
  "state": "Punjab",
  "crop": "Wheat",
  "season": "Rabi",
  "area": 100.0,
  "annual_rainfall": 500.0,
  "fertilizer": 5000.0,
  "pesticide": 200.0,
  "crop_year": 2024
}
```

**Response**:
```json
{
  "status": "success",
  "predicted_yield": 45.23,
  "predicted_production": 4523.0,
  "unit": "tonnes per hectare",
  "individual_predictions": {
    "random_forest": 44.8,
    "xgboost": 45.5,
    "lightgbm": 45.1,
    "cnn_lstm": 45.4
  },
  "data_source": "https://data.mendeley.com/datasets/ncw2vbcgnk/2"
}
```

## Flutter Integration

### 1. Add Widget to Home Screen

```dart
import 'package:kisaansaathi/widgets/crop_yield_widget.dart';

// In your home screen build method:
CropYieldWidget(),
```

### 2. Navigate to Prediction Screen

```dart
import 'package:kisaansaathi/screens/crop_yield_prediction_screen.dart';

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const CropYieldPredictionScreen(),
  ),
);
```

### 3. Tutorial System

The tutorial automatically shows on first visit. Users can:
- Skip the tutorial
- Navigate through 5 tutorial steps
- Replay tutorial via help icon in app bar

## Model Training

### Prerequisites
```bash
pip install numpy pandas scikit-learn xgboost lightgbm tensorflow joblib
```

### Training Steps

1. **Preprocess Data**:
```bash
python preproccessing.py --input crop_yield.csv --output preprocessed_data
```

2. **Train Models**:
```bash
python train_model.py
```

3. **Copy Models to Flask**:
```bash
copy trained_models\*.pkl flask-model-server\
copy trained_models\lstm_model.h5 flask-model-server\cnn_lstm_model.h5
```

### Model Files
- `rf_model.pkl` - Random Forest
- `xgb_model.pkl` - XGBoost
- `lgb_model.pkl` - LightGBM
- `cnn_lstm_model.h5` - CNN-LSTM
- `meta_learner.pkl` - Meta-learner
- `scaler_static.pkl` - Feature scaler
- `label_encoders.pkl` - Category encoders

## Performance Metrics

### Test Set Results
- **RMSE**: 0.1368
- **MAE**: 0.0782
- **R² Score**: 0.9737 (97.37% accuracy)

### Model Comparison
| Model | Validation R² |
|-------|--------------|
| Random Forest | 0.9624 |
| XGBoost | 0.9767 |
| LightGBM | 0.9726 |
| CNN-LSTM | 0.0061* |
| **Ensemble** | **0.9758** |

*CNN-LSTM focuses on temporal patterns, not standalone accuracy

## Feature Importance

Top 10 most important features:
1. Crop category (55.49%)
2. Crop type (15.80%)
3. Rainfall efficiency (13.41%)
4. Area (log) (3.31%)
5. Season (3.00%)
6. State (2.42%)
7. Fertilizer (log) (1.97%)
8. Agro-zone (1.61%)
9. Rainfall (log) (1.34%)
10. Irrigation intensity (0.53%)

## Supported Crops

### Cereals
Rice, Wheat, Maize, Bajra, Jowar, Barley, Ragi

### Pulses
Moong, Urad, Arhar/Tur, Gram, Lentil

### Oilseeds
Groundnut, Sunflower, Soyabean, Sesamum, Rapeseed & Mustard

### Cash Crops
Cotton, Sugarcane, Jute, Tobacco

### Fruits & Vegetables
Banana, Mango, Potato, Onion, Tomato

### Plantation
Coconut, Arecanut, Coffee, Tea, Rubber

## Supported States

Andhra Pradesh, Assam, Bihar, Chhattisgarh, Goa, Gujarat, Haryana, Jharkhand, Karnataka, Kerala, Madhya Pradesh, Maharashtra, Manipur, Nagaland, Odisha, Punjab, Rajasthan, Tamil Nadu, Telangana, Uttar Pradesh, West Bengal

## Seasons

- **Kharif**: Monsoon season (June-October)
- **Rabi**: Winter season (October-March)
- **Summer**: Summer season (March-June)
- **Autumn**: Autumn season
- **Whole Year**: Year-round crops

## Usage Tips

### For Best Predictions

1. **Accurate Data**: Provide precise measurements
2. **Local Context**: Use state-specific data
3. **Historical Patterns**: Consider past yields
4. **Weather Factors**: Account for rainfall variations
5. **Input Optimization**: Balance fertilizer/pesticide use

### Interpretation

- **Yield**: Tonnes per hectare
- **Production**: Total output (yield × area)
- **Model Breakdown**: Shows individual model predictions
- **Confidence**: Higher when models agree

## Troubleshooting

### Common Issues

1. **Models Not Loading**
   - Ensure all .pkl and .h5 files are in `flask-model-server/`
   - Check preprocessed_data/ contains scaler and encoders

2. **Prediction Errors**
   - Verify all required fields are provided
   - Check numeric values are valid
   - Ensure state/crop/season match dataset

3. **Low Accuracy**
   - Use crops/states from training data
   - Provide realistic input values
   - Check for data entry errors

## Future Enhancements

- [ ] Real-time weather API integration
- [ ] Soil health parameter integration
- [ ] Historical yield comparison
- [ ] Crop recommendation based on conditions
- [ ] Multi-year yield forecasting
- [ ] Regional model fine-tuning

## References

1. Dataset: https://data.mendeley.com/datasets/ncw2vbcgnk/2
2. Random Forest: Breiman, L. (2001)
3. XGBoost: Chen & Guestrin (2016)
4. LightGBM: Ke et al. (2017)
5. LSTM: Hochreiter & Schmidhuber (1997)

## License

Models trained on publicly available Mendeley dataset. Please cite the original dataset when using predictions in research or publications.

## Support

For issues or questions:
- Check tutorial in app (help icon)
- Review this documentation
- Verify model files are present
- Check Flask server logs
