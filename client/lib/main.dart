import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Roulette',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Restaurant Roulette')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 20), // Space between buttons
              ElevatedButton(
                onPressed: () {
                  // Second button does nothing
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  String? gender;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool validateInputs() {
    if (firstNameController.text.isEmpty) {
      showError('First Name is required');
      return false;
    }
    if (lastNameController.text.isEmpty) {
      showError('Last Name is required');
      return false;
    }
    if (usernameController.text.isEmpty) {
      showError('Username is required');
      return false;
    }
    if (emailController.text.isEmpty) {
      showError('Email is required');
      return false;
    }
    // Email validation regex
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(emailController.text)) {
      showError('Invalid email format');
      return false;
    }
    if (passwordController.text.isEmpty) {
      showError('Password is required');
      return false;
    }
    if (passwordController.text.length < 6) {
      showError('Password must be at least 6 characters');
      return false;
    }
    final phoneRegex = RegExp(r'^\d{3}\d{3}\d{4}$');
    if (!phoneRegex.hasMatch(phoneNumberController.text)) {
      showError('Phone Number must be in the format: xxxyyyzzzz');
      return false;
    }
    if (gender == null) {
      showError('Gender is required');
      return false;
    }
    return true;
  }

  Future<void> registerUser() async {
    if (!validateInputs()) return; // Exit if inputs are invalid

    // Prepare user data
    final userData = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'username': usernameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'gender': gender,
      'phoneNumber': phoneNumberController.text,
    };

    const String apiUrl =
        'http://10.0.2.2:3000/api/auth/register'; // Replace with your actual API URL

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User registered successfully')),
        );
        Navigator.pop(context); // Navigate back to previous page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: ${response.body}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during registration')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              DropdownButton<String>(
                hint: const Text('Select Gender'),
                value: gender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    gender = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  registerUser();
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
