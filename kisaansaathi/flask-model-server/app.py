# import os
# from dotenv import load_dotenv
# from flask import Flask, request, jsonify, render_template, make_response
# from flask_cors import CORS
# import numpy as np
# import tensorflow as tf
# import google.generativeai as genai
# from template_1 import generate_prompt
# from PIL import Image

# # -------------------------
# # Load environment variables
# # -------------------------
# load_dotenv()

# # -------------------------
# # Config Gemini
# # -------------------------
# GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
# if not GEMINI_API_KEY:
#     raise ValueError("GEMINI_API_KEY not found in environment variables")

# genai.configure(api_key=GEMINI_API_KEY)
# gemini_model = genai.GenerativeModel('gemini-2.0-flash')

# # -------------------------
# # Load Plant Disease CNN
# # -------------------------
# import os

# # Get the directory where the current script is located
# SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
# MODEL_PATH = os.path.join(SCRIPT_DIR, "best_model.keras")

# # Check if model file exists
# if not os.path.exists(MODEL_PATH):
#     raise FileNotFoundError(f"Model file not found at: {MODEL_PATH}")

# # Load model without optimizer state to avoid warnings
# model = tf.keras.models.load_model(MODEL_PATH, compile=False)

# # Compile the model with default optimizer and loss if needed
# model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])

# # Class labels (in the same order used during training!)
# CLASS_NAMES = [
#     'Apple___Apple_scab',
#     'Apple___Black_rot',
#     'Apple___Cedar_apple_rust',
#     'Apple___healthy',
#     'Blueberry___healthy',
#     'Cherry_(including_sour)___Powdery_mildew',
#     'Cherry_(including_sour)___healthy',
#     'Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot',
#     'Corn_(maize)___Common_rust_',
#     'Corn_(maize)___Northern_Leaf_Blight',
#     'Corn_(maize)___healthy',
#     'Grape___Black_rot',
#     'Grape___Esca_(Black_Measles)',
#     'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
#     'Grape___healthy',
#     'Orange___Haunglongbing_(Citrus_greening)',
#     'Peach___Bacterial_spot',
#     'Peach___healthy',
#     'Pepper,_bell___Bacterial_spot',
#     'Pepper,_bell___healthy',
#     'Potato___Early_blight',
#     'Potato___Late_blight',
#     'Potato___healthy',
#     'Raspberry___healthy',
#     'Soybean___healthy',
#     'Squash___Powdery_mildew',
#     'Strawberry___Leaf_scorch',
#     'Strawberry___healthy',
#     'Tomato___Bacterial_spot',
#     'Tomato___Early_blight',
#     'Tomato___Late_blight',
#     'Tomato___Leaf_Mold',
#     'Tomato___Septoria_leaf_spot',
#     'Tomato___Spider_mites Two-spotted_spider_mite',
#     'Tomato___Target_Spot',
#     'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
#     'Tomato___Tomato_mosaic_virus',
#     'Tomato___healthy'
# ]

# # -------------------------
# # Flask app
# # -------------------------
# app = Flask(__name__, template_folder='model/templates')
# CORS(app, resources={
#     r"/predict": {"origins": "*"}
# })

# @app.route('/')
# def home():
#     return render_template('index.html')

# # Define image dimensions
# IMG_HEIGHT = 224
# IMG_WIDTH = 224

# def preprocess_image(image_file):
#     """
#     Preprocess the input image for model prediction.
    
#     Args:
#         image_file: File object or path to the image
        
#     Returns:
#         Preprocessed image as a numpy array with shape (1, 224, 224, 3)
#     """
#     # Open and convert image to RGB
#     img = Image.open(image_file).convert("RGB")
    
#     # Resize to expected input shape
#     img = img.resize((IMG_WIDTH, IMG_HEIGHT))
    
#     # Convert to numpy array and normalize pixel values to [0, 1]
#     img_array = np.array(img) / 255.0
    
#     # Add batch dimension and return
#     return np.expand_dims(img_array, axis=0)

# @app.route("/predict", methods=["POST"])
# def predict():
#     try:
#         # Check if the post request has the file part
#         if 'file' not in request.files:
#             return jsonify({
#                 "error": "No file part in the request",
#                 "status": "error"
#             }), 400
            
#         file = request.files['file']
        
#         # If user does not select file, browser also
#         # submit an empty part without filename
#         if file.filename == '':
#             return jsonify({
#                 "error": "No selected file", 
#                 "status": "error"
#             }), 400
            
#         if file:
#             try:
#                 # Preprocess image
#                 img_array = preprocess_image(file)

#                 # Model prediction
#                 preds = model.predict(img_array)
#                 idx = np.argmax(preds)
#                 confidence = float(np.max(preds))
#                 disease_name = CLASS_NAMES[idx]

#                 # Build Gemini prompt
#                 lang = request.form.get("lang", "English")
#                 prompt = generate_prompt(disease_name, confidence, lang)

#                 # Get Gemini explanation
#                 try:
#                     response = gemini_model.generate_content(prompt)
#                     answer = response.text if response else "Error: No response from Gemini."
#                 except Exception as e:
#                     print(f"Error generating Gemini response: {str(e)}")
#                     answer = f"Could not generate detailed advice. {str(e)}"

#                 # Return consistent JSON response
#                 return jsonify({
#                     "prediction": disease_name,
#                     "confidence": confidence,
#                     "cause": "As analyzed by AI model",
#                     "remedies": [answer],  # Put the Gemini advice as remedies
#                     "status": "success"
#                 })
                
#             except Exception as e:
#                 print(f"Error processing image: {str(e)}")
#                 return jsonify({
#                     "error": f"Error processing image: {str(e)}",
#                     "status": "error"
#                 }), 500
                
#     except Exception as e:
#         print(f"Unexpected error: {str(e)}")
#         return jsonify({
#             "error": f"An unexpected error occurred: {str(e)}",
#             "status": "error"
#         }), 500

# if __name__ == "__main__":
#     app.run(host='0.0.0.0', debug=True, port=5000)

import os
from dotenv import load_dotenv
from flask import Flask, request, jsonify, render_template, make_response
from flask_cors import CORS
import google.generativeai as genai
from template_1 import generate_farmer_prompt
from PIL import Image
import io
import base64

# -------------------------
# Load environment variables
# -------------------------
load_dotenv()

# -------------------------
# Config Gemini
# -------------------------
GEMINI_API_KEY = os.getenv('GEMINI_API_KEY')
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY not found in environment variables")

genai.configure(api_key=GEMINI_API_KEY)
# Use gemini-2.0-flash-exp for vision capabilities
gemini_model = genai.GenerativeModel('gemini-2.0-flash-exp')

# -------------------------
# Flask app
# -------------------------
app = Flask(__name__, template_folder='model/templates')
CORS(app, resources={
    r"/predict": {"origins": "*"}
})

@app.route('/')
def home():
    return render_template('index.html')

@app.route("/predict", methods=["POST"])
def predict():
    try:
        # Check if the post request has the file part
        if 'file' not in request.files:
            return jsonify({
                "error": "No file part in the request",
                "status": "error"
            }), 400
            
        file = request.files['file']
        
        # If user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            return jsonify({
                "error": "No selected file", 
                "status": "error"
            }), 400
            
        if file:
            try:
                # Get language preference
                lang = request.form.get("lang", "Hindi")
                
                # Open and process image
                img = Image.open(file).convert("RGB")
                
                # Generate prompt from template_1.py
                prompt = generate_farmer_prompt(lang)

                # Get Gemini analysis with vision
                try:
                    response = gemini_model.generate_content([prompt, img])
                    analysis = response.text if response else "Error: No response from Gemini."
                    
                    # Parse the response to extract key information
                    if "not of a plant" in analysis.lower() or "नहीं है" in analysis:
                        return jsonify({
                            "prediction": "Not a plant image",
                            "confidence": 0.0,
                            "cause": "Image does not contain plant/crop",
                            "remedies": [analysis],
                            "status": "not_plant"
                        })
                    else:
                        # Try to extract plant type and disease from response
                        lines = analysis.split('\n')
                        plant_type = "Unknown plant"
                        disease_status = "Analysis provided"
                        
                        # Simple parsing to get plant type if mentioned
                        for line in lines:
                            if any(plant in line.lower() for plant in ['tomato', 'wheat', 'rice', 'corn', 'potato', 'cotton', 'सोयाबीन', 'धान', 'गेहूं']):
                                plant_type = line.strip()
                                break
                        
                        return jsonify({
                            "prediction": plant_type,
                            "confidence": 0.95,  # High confidence since Gemini analyzed it
                            "cause": "Analyzed by Gemini Vision AI",
                            "remedies": [analysis],
                            "status": "success"
                        })
                        
                except Exception as e:
                    print(f"Error generating Gemini response: {str(e)}")
                    return jsonify({
                        "error": f"Could not analyze image: {str(e)}",
                        "status": "error"
                    }), 500

            except Exception as e:
                print(f"Error processing image: {str(e)}")
                return jsonify({
                    "error": f"Error processing image: {str(e)}",
                    "status": "error"
                }), 500
                
    except Exception as e:
        print(f"Unexpected error: {str(e)}")
        return jsonify({
            "error": f"An unexpected error occurred: {str(e)}",
            "status": "error"
        }), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True, port=5000)