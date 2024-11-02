from flask import Flask, request, jsonify
import torch
from torchvision import transforms
from PIL import Image
import io
import numpy as np
import torch.nn as nn
from torchvision import models
from flask_cors import CORS

app = Flask(__name__)

CORS(app) 


class SpineClassifier(nn.Module):
    def __init__(self, num_classes=3):
        super(SpineClassifier, self).__init__()
        self.features = models.efficientnet_b0(pretrained=True)
        self.features.classifier[1] = nn.Linear(in_features=1280, out_features=num_classes)

    def forward(self, x):
        return self.features(x)

model = SpineClassifier(num_classes=3)
model.eval()  # Set to evaluation mode


transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.Grayscale(num_output_channels=3),
    transforms.ToTensor(),
])

class_names = ['Normal/Mild', 'Moderate', 'Severe']

def predict(image):
    image = transform(image).unsqueeze(0)  
    with torch.no_grad():
        outputs = model(image)
        probabilities = torch.softmax(outputs, dim=1).numpy()
    return probabilities[0] 

@app.route('/predict', methods=['POST'])
def classify_spine():
    if 'file' not in request.files:
        return jsonify({'error': 'No file provided'}), 400
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400

    image = Image.open(io.BytesIO(file.read())).convert('RGB')
    probabilities = predict(image)

    max_index = np.argmax(probabilities) 
    predicted_class = class_names[max_index] 

    if predicted_class == 'Normal/Mild':
        condition = "No significant issue"  
        detail = "Minimal or no significant narrowing or degeneration" 
    elif predicted_class == 'Moderate':
        condition = "Moderate spinal issues"
        detail = "Moderate narrowing or degeneration, potentially causing mild symptoms." 
    elif predicted_class == 'Severe':
        condition = "Severe spinal issues"  
        detail = "Significant narrowing or degeneration, likely leading to more pronounced symptoms"

    
    predictions = {class_names[i]: float(probabilities[i]) for i in range(len(class_names))}

    
    response = {
        "condition": condition,
        "detail": detail,
        "predictions": predictions
    }

    return jsonify(response)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
