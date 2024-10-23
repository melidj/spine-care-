import 'package:app/screen/login.dart';
import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Add the Image
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(150.0), // Adjust the radius as needed
              child: Image.asset(
                'assets/getstart.png',
                height: 300,
                width: 300, // Add width to maintain aspect ratio
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              textAlign: TextAlign.center,
              "Let's Take Care of Your Spine!",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              textAlign: TextAlign.center,
              "Early detection of spine conditions at your fingertips",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                'Get Started',
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
