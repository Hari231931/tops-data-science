from flask import Flask, request, jsonify
import joblib
import pandas as pd

app = Flask(__name__)

# Load model once at startup
model = joblib.load("delivery_model.joblib")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()

    required_fields = ["distance_km", "num_items", "rain_flag"]

    # Check missing fields
    missing_fields = [field for field in required_fields if field not in data]

    if missing_fields:
        return jsonify({
            "error": "Missing required fields",
            "missing_fields": missing_fields
        }), 400

    # Create input dataframe
    input_data = pd.DataFrame({
        "distance_km": [data["distance_km"]],
        "num_items": [data["num_items"]],
        "rain_flag": [data["rain_flag"]]
    })

    prediction = model.predict(input_data)[0]

    return jsonify({
        "predicted_delivery_time_min": round(prediction, 1)
    }), 200

if __name__ == "__main__":
    app.run(debug=True)
    