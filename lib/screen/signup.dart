import 'package:app/screen/imageupload.dart';
import 'package:app/screen/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';
import 'package:app/config/config.dart'; // Import the config file

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isNotValidate = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void registerUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    if (!isValidEmail(emailController.text)) {
      setState(() {
        _isNotValidate = true; // Optionally customize this for specific errors
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        _isNotValidate = true; // Handle password mismatch
      });
      return;
    }

    setState(() {
      _isNotValidate = false; // Reset validation state
    });

    var regBody = {
      "name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(registration), // Using the base URL from config.dart
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadImageScreen()),
        );
      } else {
        print("Registration failed: ${jsonResponse['message']}");
      }
    } catch (e) {
      print("Error occurred: $e");
      // Optionally show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to SpineCare+!',
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
            const SizedBox(height: 50),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                errorText: _isNotValidate && !isValidEmail(emailController.text)
                    ? 'Invalid Email'
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                errorText: _isNotValidate ? 'Please enter your password' : null,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock),
                errorText: _isNotValidate &&
                        passwordController.text !=
                            confirmPasswordController.text
                    ? 'Passwords do not match'
                    : null,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: registerUser,
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
                'Register',
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
            ),

            const SizedBox(height: 30),
            RichText(
              text: TextSpan(style: const TextStyle(fontSize: 16), children: [
                const TextSpan(text: "Already have an account? "),
                TextSpan(
                  text: 'Log In',
                  style: const TextStyle(color: Colors.blue, fontSize: 16),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Navigate to Login screen when 'Log In' text is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
