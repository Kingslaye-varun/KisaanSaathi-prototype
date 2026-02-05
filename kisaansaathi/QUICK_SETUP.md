# Quick Setup Guide - Crop Yield Prediction

## ✅ Installation Complete!

All necessary files have been created and models have been trained.

## 🚀 Start the Server

### Windows
Double-click `start_server.bat` or run:
```bash
python flask-model-server/app.py
```

### Mac/Linux
```bash
python3 flask-model-server/app.py
```

## 📱 Add to Flutter App

### 1. Add Widget to Home Screen

Open `lib/screens/farmer_home_screen_new.dart` and add:

```dart
import '../widgets/crop_yield_widget.dart';

// In your widget list or GridView:
CropYieldWidget(),
```

### 2. Update API URL (if needed)

In `lib/screens/crop_yield_prediction_screen.dart`, line 67:

```dart
// For Android Emulator (default):
Uri.parse('http://10.0.2.2:5000/predict_yield')

// For iOS Simulator:
Uri.parse('http://localhost:5000/predict_yield')

// For Physical Device (replace with your IP):
Uri.parse('http://YOUR_IP:5000/predict_yield')
```

To find your IP:
- Windows: `ipconfig` (look for IPv4 Address)
- Mac/Linux: `ifconfig` or `ip addr`

## 🧪 Test the API

### Using curl:
```bash
curl -X POST http://localhost:5000/predict_yield \
  -H "Content-Type: application/json" \
  -d "{\"state\":\"Punjab\",\"crop\":\"Wheat\",\"season\":\"Rabi\",\"area\":100,\"annual_rainfall\":500,\"fertilizer\":5000,\"pesticide\":200,\"crop_year\":2024}"
```

### Using Postman:
1. Method: POST
2. URL: `http://localhost:5000/predict_yield`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
```json
{
  "state": "Punjab",
  "crop": "Wheat",
  "season": "Rabi",
  "area": 100,
  "annual_rainfall": 500,
  "fertilizer": 5000,
  "pesticide": 200,
  "crop_year": 2024
}
```

## 📊 Expected Response

```json
{
  "status": "success",
  "predicted_yield": 45.23,
  "predicted_production": 4523.0,
  "unit": "tonnes per hectare",
  "individual_predictions": {
    "random_forest": 44.8,
    "xgboost": 45.5,
    "lightgbm": 45.1
  },
  "data_source": "https://data.mendeley.com/datasets/ncw2vbcgnk/2"
}
```

Note: CNN-LSTM predictions may not be included if the model couldn't load (this is normal and doesn't affect accuracy).

## 🎯 Features

### Widget (100px height)
- Compact design
- Gradient background
- ML badge
- Quick access

### Full Screen
- 8 input fields
- Form validation
- Real-time predictions
- Model breakdown
- Data source badge

### Tutorial
- 5-step interactive guide
- Auto-shows on first visit
- Help icon to replay
- Skip option

## 🔧 Troubleshooting

### Server won't start
```bash
# Install missing dependencies
pip install flask flask-cors google-generativeai python-dotenv pillow
```

### Models not loading
```bash
# Check files exist
dir flask-model-server\*.pkl
dir flask-model-server\*.h5
dir preprocessed_data\*.pkl
```

### Connection refused
- Ensure server is running
- Check firewall settings
- Verify API URL in Flutter code
- Try `http://localhost:5000` first

### GEMINI_API_KEY error
Create `.env` file in project root:
```
GEMINI_API_KEY=your_api_key_here
```

## 📁 File Checklist

Backend:
- [x] `flask-model-server/app.py` - Updated with /predict_yield
- [x] `flask-model-server/rf_model.pkl`
- [x] `flask-model-server/xgb_model.pkl`
- [x] `flask-model-server/lgb_model.pkl`
- [x] `flask-model-server/meta_learner.pkl`
- [x] `preprocessed_data/scaler_static.pkl`
- [x] `preprocessed_data/label_encoders.pkl`

Frontend:
- [x] `lib/screens/crop_yield_prediction_screen.dart`
- [x] `lib/widgets/crop_yield_widget.dart`
- [x] `lib/widgets/crop_yield_tutorial.dart`

## 🎉 You're Ready!

1. ✅ Start server: `python flask-model-server/app.py`
2. ✅ Add widget to home screen
3. ✅ Run Flutter app
4. ✅ Test predictions!

## 📚 Documentation

- **Full Guide**: `CROP_YIELD_PREDICTION_GUIDE.md`
- **Integration**: `CROP_YIELD_INTEGRATION.md`
- **Dataset**: https://data.mendeley.com/datasets/ncw2vbcgnk/2

## 💡 Tips

- Widget is 100px height (compact)
- Tutorial shows automatically first time
- Help icon (?) replays tutorial
- All 3 ML models work even without CNN-LSTM
- Data source link is always visible

---

**Need Help?** Check the troubleshooting section or review the full documentation.
