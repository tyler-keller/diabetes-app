import os
import torch
from flask import Flask, request, jsonify

MODEL_PATH = os.environ.get("MODEL_PATH", "model.pth")

app = Flask(__name__)

# Load the PyTorch model at startup
try:
    model = torch.load(MODEL_PATH, map_location=torch.device("cpu"))
    model.eval()
except FileNotFoundError:
    model = None
    print(f"Warning: model file '{MODEL_PATH}' not found. Predictions will fail.")


def preprocess(readings):
    """Convert a list of reading dicts to a tensor.

    Expected keys in each reading: 'value' and 'trendRate'.
    """
    features = [
        [r.get("value", 0), r.get("trendRate", 0.0)] for r in readings
    ]
    return torch.tensor(features, dtype=torch.float32)


@app.route("/predict", methods=["POST"])
def predict():
    if model is None:
        return jsonify({"error": "Model not loaded"}), 500

    data = request.get_json(force=True)
    readings = data.get("readings", [])
    if not readings:
        return jsonify({"error": "No readings provided"}), 400

    inputs = preprocess(readings)
    with torch.no_grad():
        outputs = model(inputs)

    # Convert output tensor to list for JSON serialization
    return jsonify({"prediction": outputs.tolist()})


if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
