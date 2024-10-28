import 'package:flutter/material.dart';
import 'package:app/screen/firstaid.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiagnosisResultScreen extends StatefulWidget {
  final Uint8List? _imageBytes;

  const DiagnosisResultScreen(
      {super.key, required Uint8List? imageBytes, required Map resultData})
      : _imageBytes = imageBytes;

  @override
  _DiagnosisResultScreenState createState() => _DiagnosisResultScreenState();
}

class _DiagnosisResultScreenState extends State<DiagnosisResultScreen> {
  Map<String, dynamic>? resultData;

  @override
  void initState() {
    super.initState();
    fetchResultData();
  }

  Future<void> fetchResultData() async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1:3000/predict'));
      request.files.add(
          await http.MultipartFile.fromPath('imagefile', 'path_to_your_image'));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final resultData = json.decode(String.fromCharCodes(responseData));

        setState(() {
          this.resultData = resultData;
        });
      } else {
        throw Exception(
            'Failed to load diagnosis result: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnosis Results',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: resultData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.blue, width: 2),
                      image: widget._imageBytes != null
                          ? DecorationImage(
                              image: MemoryImage(widget._imageBytes!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Diagnosis Results Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Result Section
                        ListTile(
                          leading: const Icon(Icons.description, size: 30),
                          title: const Text(
                            'Result',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          subtitle: Text(
                            resultData?["result"] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(),

                        // Confidence Level Section
                        ListTile(
                          leading: const Icon(Icons.percent, size: 30),
                          title: const Text(
                            'Confidence Level',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          subtitle: Text(
                            resultData != null
                                ? '${(resultData!["confidence"] * 100).toStringAsFixed(2)}%'
                                : '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        const Divider(),

                        // Result Assessment Section
                        ListTile(
                          leading: const Icon(Icons.assignment, size: 30),
                          title: const Text(
                            'Result Assessment',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          subtitle: Text(
                            resultData?["assessment"] ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Buttons Section
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiagnosisResultScreen2(
                            resultData: {},
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'More Details',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirstAidScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      fixedSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'First Aid',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class DiagnosisResultScreen2 extends StatelessWidget {
  const DiagnosisResultScreen2(
      {super.key, required Map<String, dynamic> resultData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnosis Results',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Section
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.blue, width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/sample_mri.jpg'), // Your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Diagnosis Results Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Impact on Health Section
                  ListTile(
                    leading: Icon(Icons.favorite, size: 30),
                    title: Text(
                      'Impact on Health',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• Pain: Osteophytes can irritate nerves, causing pain in the spine, neck, or lower back.',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• Stiffness: May limit movement and make daily tasks harder.',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '• Nerve Compression: Severe cases can cause tingling, numbness, or weakness in the limbs.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  Divider(),
                  // Advice Section
                  ListTile(
                    leading: Icon(Icons.info, size: 30),
                    title: Text(
                      'Advice',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Consult a specialist in orthopedics or spinal health for further evaluation. Treatment options may include physical therapy, medications, or in severe cases, surgical intervention.',
                      style: TextStyle(fontSize: 14),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Buttons Section
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FirstAidScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: const Size(200, 50), // Width: 200, Height: 50
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'First Aid',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Save Result',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
