import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this package to handle phone calls

class FirstAidScreen extends StatelessWidget {
  const FirstAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'First Aid for Spine Injury',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Ensures the button is at the bottom
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Ice or Heat Section
                    _buildFirstAidSection(
                      title: 'Ice or Heat',
                      description:
                          'Apply ice for 15-20 minutes every 2-3 hours to reduce swelling.\n'
                          'Use heat for stiffness relief and better blood flow.',
                      icon: Icons.ac_unit,
                    ),
                    const SizedBox(height: 20),

                    // Rest Section
                    _buildFirstAidSection(
                      title: 'Rest',
                      description:
                          'Avoid heavy lifting or bending.\nLie on a firm surface to reduce spine pressure.',
                      icon: Icons.bed,
                    ),
                    const SizedBox(height: 20),

                    // Posture Section
                    _buildFirstAidSection(
                      title: 'Posture',
                      description:
                          'Use lumbar support while sitting.\nGentle stretches may help, but stop if pain worsens.',
                      icon: Icons.chair_alt,
                    ),
                    const SizedBox(height: 20),

                    // Pain Relief Section
                    _buildFirstAidSection(
                      title: 'Pain Relief',
                      description:
                          'Take NSAIDs (e.g., ibuprofen) to reduce inflammation and pain.',
                      icon: Icons.medical_services,
                    ),
                    const SizedBox(height: 20),

                    // No Heavy Lifting Section
                    _buildFirstAidSection(
                      title: 'No Heavy Lifting',
                      description:
                          'Avoid activities that stress the spine further.',
                      icon: Icons.block,
                    ),
                    const SizedBox(height: 20),

                    // Hydration & Flexibility Section
                    _buildFirstAidSection(
                      title: 'Hydration & Flexibility',
                      description:
                          'Drink water and perform gentle range-of-motion exercises.',
                      icon: Icons.local_drink,
                    ),
                    const SizedBox(height: 20),

                    // Emergency Section
                    _buildFirstAidSection(
                      title: 'Emergency',
                      description:
                          'Call emergency services for sudden weakness, numbness, or loss of bladder/bowel control.',
                      icon: Icons.call,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          // Call 1990 Button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _launchPhoneDialer('1990');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Call 1990',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build the first aid section with an icon, title, and description
  Widget _buildFirstAidSection({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  // Function to launch the phone dialer with the provided number
  void _launchPhoneDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(phoneUri);
    } catch (e) {
      // Handle any errors that occur when launching the dialer
      print('Could not launch $phoneUri');
    }
  }
}
