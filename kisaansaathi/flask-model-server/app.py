# import os
# from dotenv import load_dotenv
# from flask import Flask, request, jsonify, render_template, make_response
# from flask_cors import CORS
# import google.generativeai as genai
# from template_1 import generate_farmer_prompt
# from PIL import Image
# import io
# import base64

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
# # Use gemini-2.0-flash-exp for vision capabilities
# gemini_model = genai.GenerativeModel('gemini-2.0-flash-exp')

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
#                 # Get language preference
#                 lang = request.form.get("lang", "Hindi")
                
#                 # Open and process image
#                 img = Image.open(file).convert("RGB")
                
#                 # Generate prompt from template_1.py
#                 prompt = generate_farmer_prompt(lang)

#                 # Get Gemini analysis with vision
#                 try:
#                     response = gemini_model.generate_content([prompt, img])
#                     analysis = response.text if response else "Error: No response from Gemini."
                    
#                     # Parse the response to extract key information
#                     if "not of a plant" in analysis.lower() or "नहीं है" in analysis:
#                         return jsonify({
#                             "prediction": "Not a plant image",
#                             "confidence": 0.0,
#                             "cause": "Image does not contain plant/crop",
#                             "remedies": [analysis],
#                             "status": "not_plant"
#                         })
#                     else:
#                         # Try to extract plant type and disease from response
#                         lines = analysis.split('\n')
#                         plant_type = "Unknown plant"
#                         disease_status = "Analysis provided"
                        
#                         # Simple parsing to get plant type if mentioned
#                         for line in lines:
#                             if any(plant in line.lower() for plant in ['tomato', 'wheat', 'rice', 'corn', 'potato', 'cotton', 'सोयाबीन', 'धान', 'गेहूं']):
#                                 plant_type = line.strip()
#                                 break
                        
#                         return jsonify({
#                             "prediction": plant_type,
#                             "confidence": 0.95,  # High confidence since Gemini analyzed it
#                             "cause": "Analyzed by Gemini Vision AI",
#                             "remedies": [analysis],
#                             "status": "success"
#                         })
                        
#                 except Exception as e:
#                     print(f"Error generating Gemini response: {str(e)}")
#                     return jsonify({
#                         "error": f"Could not analyze image: {str(e)}",
#                         "status": "error"
#                     }), 500

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

import re



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

# Enable CORS for all routes and origins (important for Flutter)

CORS(app, resources={

    r"/": {"origins": "", "methods": ["GET", "POST", "OPTIONS"], "allow_headers": ["Content-Type"]}

})



@app.route('/')

def home():

    return render_template('index.html')



def extract_plant_info(analysis_text):

    """Extract plant name, disease, and cause from Gemini response"""

    plant_name = "Plant"

    disease_cause = "Disease analysis"

    

    # Try to extract plant name from the first line or common patterns

    lines = analysis_text.split('\n')

    first_line = lines[0] if lines else ""

    

    # Look for "This is X plant" pattern in first line

    if "this is" in first_line.lower():

        parts = first_line.lower().split("this is")

        if len(parts) > 1:

            plant_part = parts[1].strip().replace("plant", "").replace(".", "").strip()

            if plant_part:

                plant_name = plant_part.title() + " plant"

    

    # Try to extract disease/cause from second line

    if len(lines) > 1:

        second_line = lines[1]

        if "caused by" in second_line.lower():

            # Extract everything after "caused by"

            cause_part = second_line.lower().split("caused by")

            if len(cause_part) > 1:

                disease_cause = cause_part[1].strip().replace(".", "")

        elif "problem is" in second_line.lower():

            # Extract the problem description

            problem_part = second_line.lower().split("problem is")

            if len(problem_part) > 1:

                disease_cause = problem_part[1].strip().replace(".", "")

    

    return plant_name, disease_cause



@app.route("/predict", methods=["POST", "OPTIONS"])

def predict():

    # Handle preflight OPTIONS request

    if request.method == "OPTIONS":

        response = make_response()

        response.headers.add("Access-Control-Allow-Origin", "*")

        response.headers.add("Access-Control-Allow-Headers", "*")

        response.headers.add("Access-Control-Allow-Methods", "*")

        return response

        

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

                    

                    # Check if it's not a plant image

                    not_plant_indicators = [

                        "not of a plant", "नहीं है", "അല്ല", "not a plant", 

                        "doesn't appear to be", "not appear to be"

                    ]

                    

                    if any(indicator in analysis.lower() for indicator in not_plant_indicators):

                        return jsonify({

                            "prediction": "Not a plant image",

                            "confidence": 0.0,

                            "cause": "Image does not contain plant/crop parts",

                            "remedies": [analysis],

                            "full_response": analysis,

                            "status": "not_plant"

                        })

                    else:

                        # Extract plant information from the response

                        plant_name, disease_cause = extract_plant_info(analysis)

                        

                        # Clean up the analysis to ensure it's exactly 10 lines

                        analysis_lines = [line.strip() for line in analysis.split('\n') if line.strip()]

                        if len(analysis_lines) > 10:

                            analysis_lines = analysis_lines[:10]

                        elif len(analysis_lines) < 10:

                            # If less than 10 lines, pad with empty lines to maintain structure

                            while len(analysis_lines) < 10:

                                analysis_lines.append("")

                        

                        clean_analysis = '\n'.join(analysis_lines)

                        

                        return jsonify({

                            "prediction": plant_name,

                            "confidence": 0.95,  # Keep confidence for compatibility

                            "cause": disease_cause,

                            "remedies": [clean_analysis],

                            "full_response": clean_analysis,

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

    # Important: Use 0.0.0.0 to allow external connections

    # Get your machine's IP address for Flutter to connect

    import socket

    hostname = socket.gethostname()

    local_ip = socket.gethostbyname(hostname)

    

    print(f"Starting server...")

    print(f"Local access: http://localhost:5000")

    print(f"Network access: http://{local_ip}:5000")

    print(f"For Flutter app, use: http://{local_ip}:5000/predict")

    print(f"For Android emulator, use: http://10.0.2.2:5000/predict")

    

    app.run(host='0.0.0.0', debug=True, port=5000)