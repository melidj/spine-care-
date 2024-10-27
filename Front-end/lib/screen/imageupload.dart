import 'dart:typed_data';
import 'package:app/screen/imageanalyzing.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class UploadImageScreen extends StatefulWidget {
  final String token;

  const UploadImageScreen({required this.token, Key? key}) : super(key: key);

  @override
  State<UploadImageScreen> createState() => _UploadImageScreen();
}

class _UploadImageScreen extends State<UploadImageScreen> {
  late String email;
  Uint8List?
      _imageBytes; // Store the image bytes for cross-platform compatibility

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageBytes == null) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:5001/predict'),
    );

    request.files.add(
      http.MultipartFile.fromBytes('file', _imageBytes!,
          filename: 'upload.jpg'),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageAnalyzeScreen(result: respStr),
        ),
      );
    } else {
      print('Upload failed with status: ${response.statusCode}');
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
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: _imageBytes == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'Select file',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      )
                    : Image.memory(
                        _imageBytes!,
                        fit: BoxFit.cover,
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
            ElevatedButton(
              onPressed: _uploadImage,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                backgroundColor: Colors.blue,
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
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
