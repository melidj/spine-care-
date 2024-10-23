import 'package:app/screen/imageupload.dart';
import 'package:app/screen/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Welcome Text
            const Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            const Text(
              'Empowering Your Spine Health Journey',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(179, 5, 2, 51),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Spine Image
            Image.asset(
              'assets/img-login.png',
              height: 150,
            ),
            const SizedBox(height: 30),

            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UploadImageScreen()),
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
                'Login',
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
                text: TextSpan(style: const TextStyle(fontSize: 16), children: [
              const TextSpan(text: "Don't have an account? "),
              TextSpan(
                  text: 'Sign Up',
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      //Navigate to Sign Up screen when 'Sign Up' text is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()),
                      );
                    })
            ]))
          ],
        ),
      ),
    );
  }
}
