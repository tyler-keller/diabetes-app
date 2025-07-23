# Prediction Service

This directory contains a small Flask application that loads a PyTorch `.pth` model and exposes a `/predict` endpoint. It expects CGM (Continuous Glucose Monitoring) readings from the client and returns the model output.

## Setup

1. Install Python dependencies:

```bash
pip install -r requirements.txt
```

2. Place your trained model file named `model.pth` in this directory (or specify the `MODEL_PATH` environment variable).

## Running

Start the Flask server:

```bash
python app.py
```

By default the service listens on port `5000`. You can change the port by setting the `PORT` environment variable.

## API

`POST /predict`

Request JSON body:

```json
{
  "readings": [
    {"value": 100, "trendRate": 0.5},
    {"value": 105, "trendRate": 0.6}
  ]
}
```

Each reading should include at least the `value` and `trendRate` fields. Additional fields are ignored.

Response body:

```json
{"prediction": [ ... ]}
```

The returned list corresponds to the output of the model for each provided reading.
