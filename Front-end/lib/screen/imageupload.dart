import 'package:app/screen/firstaid.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class UploadImageScreen extends StatefulWidget {
  final String token;

  const UploadImageScreen({required this.token, Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreen();
}

class _UploadImageScreen extends State<UploadImageScreen> {
  late String email;
  File? _image;
  Uint8List? _webImage; // For storing the image bytes on web
  String result = "";
  Map<String, dynamic>? probabilities;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // Read image as bytes for web compatibility
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = imageBytes;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _showResult() async {
    if (_image == null && _webImage == null) {
      setState(() {
        result = "Please select an image first.";
      });
      return;
    }

    // Create a multipart request with the image bytes
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/predict'),
    );

    if (kIsWeb) {
      // For web, use _webImage as bytes
      request.files.add(http.MultipartFile.fromBytes('file', _webImage!,
          filename: 'uploaded_image.jpg'));
    } else {
      // For mobile, use _image file
      final imageBytes = await _image!.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('file', imageBytes,
          filename: _image!.path.split('/').last));
    }

    // Send the request and handle the response
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      Map<String, dynamic> resultData = jsonDecode(responseData.body);

      setState(() {
        result = "Diagnosis Results:";
        probabilities = resultData; // Store result probabilities to display
      });
    } else {
      setState(() {
        result = "Failed to retrieve result from server";
      });
    }
  }

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
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Upload a photo of your X-ray/MRI for the most accurate diagnosis. '
              'You can also take a picture, but this may result in lower accuracy.',
              style: TextStyle(fontSize: 8, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Center(
                  child: (_image == null && _webImage == null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.image, size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Select file",
                                style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : (kIsWeb
                          ? Image.memory(_webImage!) // Display for web
                          : Image.file(_image!)), // Display for mobile
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
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {},
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

            const SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _showResult,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50), // Width: 200, Height: 50
                    textStyle:
                        const TextStyle(fontSize: 20), // Button text size
                    backgroundColor: Colors.blue, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corner radius
                    ),
                  ),
                  child: const Text(
                    'Show Result',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Display result and probabilities if available
            if (result.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (probabilities != null)
                      ...probabilities!.entries.map((entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${(entry.value * 100).toStringAsFixed(2)}%",
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 5),
                            ],
                          )),
                  ],
                ),
              ),

            const SizedBox(height: 180),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirstAidScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50), // Width: 200, Height: 50
                textStyle: const TextStyle(fontSize: 20), // Button text size
                backgroundColor: Colors.blue, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Rounded corner radius
                ),
              ),
              child: const Text(
                'First Aid',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
