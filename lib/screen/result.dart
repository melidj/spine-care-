import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app/screen/firstaid.dart';

class DiagnosisResultScreen extends StatelessWidget {
  const DiagnosisResultScreen({super.key});

  Future<void> savePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Diagnosis Results',
                  style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Result: Osteophytes'),
              pw.Text('Confidence Level: 93%'),
              pw.Text('Result Assessment: Osteophytes are bony growths...'),
              pw.Text(
                  'Impact on Health: Generally harmless but can cause issues.'),
              pw.Text('Advice: Consult a healthcare professional.'),
              pw.Text('First Aid: Rest and avoid strain.'),
            ],
          );
        },
      ),
    );
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/diagnosis_results.pdf');
    await file.writeAsBytes(await pdf.save());
    // Show a toast notification
    Fluttertoast.showToast(
      msg: "PDF saved successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
            const SizedBox(height: 14),

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
                  // Result Section
                  ListTile(
                    leading: Icon(Icons.description, size: 30),
                    title: Text(
                      'Result',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    subtitle: Text(
                      'Osteophytes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  Divider(),
                  // Confidence Level Section
                  ListTile(
                    leading: Icon(Icons.percent, size: 30),
                    title: Text(
                      'Confidence Level',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    subtitle: Text(
                      '93%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  Divider(),
                  // Result Assessment Section
                  ListTile(
                    leading: Icon(Icons.assignment, size: 30),
                    title: Text(
                      'Result Assessment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Osteophytes are bony growths that form on the edges of your bones, '
                      'often in joints like the spine. While they are generally harmless, '
                      'they can cause issues when they grow large or press on surrounding tissues or nerves.',
                      style: TextStyle(fontSize: 14),
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
                    builder: (context) => const DiagnosisResultScreen2(),
                  ),
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
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                savePdf();
              },
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

class DiagnosisResultScreen2 extends StatelessWidget {
  const DiagnosisResultScreen2({super.key});

  Future<void> savePdf() async {
    final pdf = pw.Document();

    // Add a page to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Diagnosis Results',
                  style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Result: Osteophytes'),
              pw.Text('Confidence Level: 93%'),
              pw.Text('Result Assessment: Osteophytes are bony growths...'),
              pw.Text(
                  'Impact on Health: Generally harmless but can cause issues.'),
              pw.Text('Advice: Consult a healthcare professional.'),
              pw.Text('First Aid: Rest and avoid strain.'),
            ],
          );
        },
      ),
    );

    // Save the PDF to device
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/diagnosis_results.pdf');
    await file.writeAsBytes(await pdf.save());

    // Show a toast notification
    Fluttertoast.showToast(
      msg: "PDF saved successfully!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
              onPressed: () {
                savePdf();
              },
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
