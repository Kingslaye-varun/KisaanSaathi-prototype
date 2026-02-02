# TensorFlow Lite Plant Disease Detection Integration

This guide explains how to integrate your TensorFlow Lite model for plant disease detection into the KisaanSaathi app.

## Prerequisites

1. A trained TensorFlow Lite model (`.tflite` file) for plant disease detection
2. A labels file containing the class names your model can predict

## Integration Steps

### 1. Add Your Model Files

1. **Copy your TensorFlow Lite model** to:
   ```
   kisaansaathi/assets/models/plant_disease_model.tflite
   ```

2. **Update the labels file** at:
   ```
   kisaansaathi/assets/labels/labels.txt
   ```
   
   Format: One class name per line, matching your model's output classes.
   Example:
   ```
   Healthy
   Bacterial Spot
   Early Blight
   Late Blight
   Leaf Mold
   ```

### 2. Model Configuration

If your model has different specifications, update the constants in `lib/services/tflite_service.dart`:

```dart
// Update these values to match your model
static const int inputSize = 224;  // Your model's input image size
static const int numChannels = 3;  // RGB = 3, Grayscale = 1
```

### 3. Disease Information Database

Update the `diseaseInfo` map in `tflite_service.dart` to include information about the diseases your model can detect:

```dart
static const Map<String, Map<String, dynamic>> diseaseInfo = {
  'your_disease_name': {
    'cause': 'Description of what causes this disease',
    'remedies': [
      'Treatment step 1',
      'Treatment step 2',
      'Prevention measure'
    ]
  },
  // Add more diseases...
};
```

### 4. Install Dependencies

Run the following command to install the required packages:

```bash
flutter pub get
```

## Model Requirements

### Input Format
- **Image size**: Typically 224x224 pixels (configurable)
- **Color channels**: RGB (3 channels)
- **Data type**: Float32
- **Value range**: [0.0, 1.0] (normalized)

### Output Format
- **Shape**: [1, num_classes]
- **Data type**: Float32
- **Values**: Probability scores for each class

## Testing Your Integration

1. **Build and run the app**:
   ```bash
   flutter run
   ```

2. **Navigate to Disease Detection** from the home screen

3. **Test with sample images**:
   - Take photos of healthy and diseased plants
   - Verify predictions match expected results
   - Check confidence scores are reasonable

## Troubleshooting

### Common Issues

1. **Model loading fails**:
   - Verify the model file path is correct
   - Ensure the `.tflite` file is valid
   - Check file permissions

2. **Incorrect predictions**:
   - Verify labels.txt matches your model's classes
   - Check if image preprocessing matches training
   - Ensure input size matches model requirements

3. **Performance issues**:
   - Consider using quantized models for faster inference
   - Optimize image preprocessing
   - Test on different devices

### Debug Information

The app logs useful information during model loading:
- Input tensor shape
- Output tensor shape
- Number of labels loaded

Check the console output for these details.

## Model Optimization Tips

1. **Use quantized models** for better performance:
   - Convert your model to INT8 quantization
   - Reduces model size and improves speed

2. **Optimize input size**:
   - Smaller input sizes = faster inference
   - Balance between speed and accuracy

3. **Consider model pruning**:
   - Remove unnecessary parameters
   - Maintain accuracy while reducing size

## Example Model Conversion

If you have a Keras/TensorFlow model, convert it to TensorFlow Lite:

```python
import tensorflow as tf

# Load your trained model
model = tf.keras.models.load_model('your_model.h5')

# Convert to TensorFlow Lite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]  # Optional quantization
tflite_model = converter.convert()

# Save the model
with open('plant_disease_model.tflite', 'wb') as f:
    f.write(tflite_model)
```

## Support

If you encounter issues:
1. Check the Flutter and TensorFlow Lite documentation
2. Verify your model works with TensorFlow Lite Python API first
3. Test with simple images to isolate issues
4. Check device compatibility and performance

## Performance Benchmarks

Expected performance on different devices:
- **High-end phones**: < 100ms inference time
- **Mid-range phones**: 100-300ms inference time
- **Low-end phones**: 300-1000ms inference time

Actual performance depends on:
- Model complexity
- Input image size
- Device specifications
- Background processes