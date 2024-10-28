import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../api_utils.dart';

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
    final phoneRegex = RegExp(r'^\d{10}$'); // Adjusting regex for 10 digits
    if (!phoneRegex.hasMatch(phoneNumberController.text)) {
      showError('Phone Number must be in the format: xxxxxxxxxx');
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

    final String apiUrl = '${getBaseUrl()}/api/auth/register';

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
        final errorResponse = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register: ${errorResponse['message']}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during registration')),
      );
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneNumberController.dispose();
    super.dispose();
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