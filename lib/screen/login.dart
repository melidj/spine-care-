import 'package:app/screen/imageupload.dart';
import 'package:app/screen/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/config/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
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

    setState(() {
      _isNotValidate = false; // Reset validation state
    });

    var loginBody = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse('http://192.168.43.46:3000/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        // Login successful, navigate to UploadImageScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UploadImageScreen()),
        );
      } else {
        // Login failed, show error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Failed'),
              content: const Text(
                  'Invalid email or password. Please sign up if you don\'t have an account.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error occurred: $e");
      // Optionally show an error message to the user
    }
  }

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

            // Email TextField
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

            // Password TextField
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                errorText: _isNotValidate ? 'Please enter your password' : null,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 50),

            // Login Button
            ElevatedButton(
              onPressed: loginUser,
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
                'Login',
                style: TextStyle(
                  color: Colors.white, // Text color
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sign Up RichText
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
                    },
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
