from flask import Flask, request, jsonify
import torch
from torchvision import transforms
from PIL import Image
import io
import numpy as np
import torch.nn as nn
from torchvision import models

app = Flask(__name__)

# Define the SpineClassifier model
class SpineClassifier(nn.Module):
    def __init__(self, num_classes=3):
        super(SpineClassifier, self).__init__()
        self.features = models.efficientnet_b0(pretrained=True)
        self.features.classifier[1] = nn.Linear(in_features=1280, out_features=num_classes)

    def forward(self, x):
        return self.features(x)

# Load the model
model = SpineClassifier(num_classes=3)
model.eval()  # Set to evaluation mode

# Define image transformation
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.Grayscale(num_output_channels=3),
    transforms.ToTensor(),
])

# Define class names
class_names = ['normal_mild', 'moderate', 'severe']

# Prediction function
def predict(image):
    image = transform(image).unsqueeze(0)  # Add batch dimension
    with torch.no_grad():
        outputs = model(image)
        probabilities = torch.softmax(outputs, dim=1).numpy()
    return probabilities[0]  # Return probabilities as a numpy array

@app.route('/predict', methods=['POST'])
def classify_spine():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    # Load the image and apply transformations
    image = Image.open(io.BytesIO(file.read())).convert('RGB')
    probabilities = predict(image)

    # Map class probabilities to class names
    results = {class_names[i]: float(probabilities[i]) for i in range(len(class_names))}
    return jsonify(results)

if __name__ == '__main__':
    app.run(debug=True)
