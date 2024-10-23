import 'package:app/screen/imageanalyzing.dart';
import 'package:flutter/material.dart';

class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnose Your Spine',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Upload a photo of your X-ray/MRI',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Upload a photo of your X-ray/MRI for the most accurate diagnosis. '
              'You can also take a picture, but this may result in lower accuracy.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Upload Image Box
            GestureDetector(
              onTap: () {
                // Handle image selection logic here
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 50, color: Colors.grey),
                    SizedBox(height: 10),
                    Text(
                      'Select file',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text('or', style: TextStyle(color: Colors.black45)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            // Open Camera Button
            OutlinedButton.icon(
              onPressed: () {
                // Logic to open the camera goes here
              },
              icon: const Icon(Icons.camera_alt, color: Colors.blue),
              label: const Text(
                'Open Camera & Take Photo',
                style: TextStyle(color: Colors.blue),
              ),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            const SizedBox(height: 50),
            // Continue Button
            ElevatedButton(
              onPressed: () {
                // Navigation to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ImageAnalyzeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                // Set the button size
                fixedSize: const Size(200, 50), // Width: 200, Height: 50
                // Set the button background color
                backgroundColor: Colors.blue, // Button background color
                // Set the text color and size
                textStyle: const TextStyle(fontSize: 20), // Button text size
                // Set button shape (rounded corners)
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Rounded corner radius
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
