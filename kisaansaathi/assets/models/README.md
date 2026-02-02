# Plant Disease Detection Model

## Instructions

1. Place your trained TensorFlow Lite model file here with the name: `plant_disease_model.tflite`

2. The model should:
   - Accept input images of size 224x224x3 (RGB)
   - Output probabilities for each disease class
   - Be compatible with TensorFlow Lite format

3. Update the labels file at `../labels/labels.txt` to match your model's output classes

## Model Requirements

- **Input Shape**: [1, 224, 224, 3]
- **Input Type**: Float32
- **Input Range**: [0.0, 1.0] (normalized pixel values)
- **Output Shape**: [1, num_classes]
- **Output Type**: Float32 (probabilities)

## Testing

Once you've added your model:
1. Run `flutter run` to start the app
2. Navigate to Disease Detection
3. Test with sample plant images
4. Verify predictions are accurate

## Troubleshooting

If the model fails to load:
- Check the file path and name
- Verify the model is a valid .tflite file
- Ensure the model input/output shapes match the code
- Check the labels file format