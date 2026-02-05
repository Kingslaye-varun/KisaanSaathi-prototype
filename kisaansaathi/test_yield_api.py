"""
Quick test script for Crop Yield Prediction API
"""
import requests
import json

# Test data
test_data = {
    "state": "Punjab",
    "crop": "Wheat",
    "season": "Rabi",
    "area": 100,
    "annual_rainfall": 500,
    "fertilizer": 5000,
    "pesticide": 200,
    "crop_year": 2024
}

print("Testing Crop Yield Prediction API...")
print("=" * 50)

try:
    # Test the endpoint
    response = requests.post(
        'http://localhost:5000/predict_yield',
        headers={'Content-Type': 'application/json'},
        json=test_data,
        timeout=10
    )
    
    print(f"Status Code: {response.status_code}")
    print("\nResponse:")
    print(json.dumps(response.json(), indent=2))
    
    if response.status_code == 200:
        result = response.json()
        print("\n" + "=" * 50)
        print("✅ SUCCESS!")
        print(f"Predicted Yield: {result['predicted_yield']} tonnes/hectare")
        print(f"Total Production: {result['predicted_production']} tonnes")
        print("=" * 50)
    else:
        print("\n❌ ERROR: Request failed")
        
except requests.exceptions.ConnectionError:
    print("\n❌ ERROR: Could not connect to server")
    print("Make sure Flask server is running:")
    print("  python flask-model-server/app.py")
    
except Exception as e:
    print(f"\n❌ ERROR: {e}")
