import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:app/config/config.dart';
import 'package:app/screen/imageupload.dart';
import 'package:app/screen/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  late SharedPreferences prefs;

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      var response = await http.post(
        Uri.parse(login), // Using the base URL from config.dart
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      print('Response status: ${response.statusCode}');
      print(
          'Response body: ${response.body}'); // Log response body for debugging

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UploadImageScreen(token: myToken)));
      } else {
        print(
            'Something Went Wrong: ${jsonResponse['message']}'); // Update to show error message
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initSharedPref(); // Move this to initState
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void validateLogin() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    if (!isValidEmail(emailController.text)) {
      setState(() {
        _isNotValidate = true;
      });
      return;
    }

    setState(() {
      _isNotValidate = false;
    });
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
              onPressed: () {
                loginUser();
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
                      // Navigate to Sign Up screen when 'Sign Up' text is clicked
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
