from flask import Flask, request, jsonify
import numpy as np
import tensorflow as tf
import google.generativeai as genai
from template_1 import build_disease_prompt
from PIL import Image

# -------------------------
# Config Gemini
# -------------------------
GEMINI_API_KEY = "AIzaSyAh0SIXTzZPacd_vNI3neBm-1gkV1m9a-U"
genai.configure(api_key=GEMINI_API_KEY)
gemini_model = genai.GenerativeModel("gemini-2.0-flash")

# -------------------------
# Load Plant Disease CNN
# -------------------------
MODEL_PATH = "best_model.keras"
model = tf.keras.models.load_model(MODEL_PATH)

# Class labels (in the same order used during training!)
CLASS_NAMES = ['Apple___Apple_scab',
 'Apple___Black_rot',
 'Apple___Cedar_apple_rust',
 'Apple___healthy',
 'Blueberry___healthy',
 'Cherry_(including_sour)___Powdery_mildew',
 'Cherry_(including_sour)___healthy',
 'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot',
 'Corn_(maize)___Common_rust_',
 'Corn_(maize)___Northern_Leaf_Blight',
 'Corn_(maize)___healthy',
 'Grape___Black_rot',
 'Grape___Esca_(Black_Measles)',
 'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
 'Grape___healthy',
 'Orange___Haunglongbing_(Citrus_greening)',
 'Peach___Bacterial_spot',
 'Peach___healthy',
 'Pepper,_bell___Bacterial_spot',
 'Pepper,_bell___healthy',
 'Potato___Early_blight',
 'Potato___Late_blight',
 'Potato___healthy',
 'Raspberry___healthy',
 'Soybean___healthy',
 'Squash___Powdery_mildew',
 'Strawberry___Leaf_scorch',
 'Strawberry___healthy',
 'Tomato___Bacterial_spot',
 'Tomato___Early_blight',
 'Tomato___Late_blight',
 'Tomato___Leaf_Mold',
 'Tomato___Septoria_leaf_spot',
 'Tomato___Spider_mites Two-spotted_spider_mite',
 'Tomato___Target_Spot',
 'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
 'Tomato___Tomato_mosaic_virus',
 'Tomato___healthy',
 'Non_Plant___Not_a_leaf']


# -------------------------
# Flask app
# -------------------------
app = Flask(__name__)

def preprocess_image(image_file, target_size=(224, 224)):
    img = Image.open(image_file).convert("RGB")
    img = img.resize(target_size)
    img_array = np.array(img) / 255.0
    return np.expand_dims(img_array, axis=0)

@app.route("/predict", methods=["POST"])
def predict():
    file = request.files.get("file")
    lang = request.form.get("lang", "English")

    # Preprocess image
    img_array = preprocess_image(file)

    # Model prediction
    preds = model.predict(img_array)
    idx = np.argmax(preds)
    confidence = float(np.max(preds))
    disease_name = CLASS_NAMES[idx]

    # Build Gemini prompt
    prompt = build_disease_prompt(disease_name, confidence, lang)

    # Get Gemini explanation
    response = gemini_model.generate_content(prompt)
    answer = response.text if response else "Error: No response from Gemini."

    return jsonify({
        "disease": disease_name,
        "confidence": confidence,
        "language": lang,
        "advice": answer
    })

if __name__ == "__main__":
    app.run(debug=True)
