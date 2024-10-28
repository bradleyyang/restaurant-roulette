import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'dashboard_page.dart';
import '../api_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // State to manage loading indicator

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> loginUser() async {
    final String apiUrl =
        '${getBaseUrl()}/api/auth/login'; // Update with your API URL

    final Map<String, String> userData = {
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      if (response.statusCode == 200) {
        // Login successful
        final responseData = json.decode(response.body);

        // Create user instance with full data from the response
        final user = User(
          username: responseData['user']['username'],
          firstName: responseData['user']['firstName'],
          lastName: responseData['user']['lastName'],
          email: responseData['user']['email'],
          phoneNumber: responseData['user']['phoneNumber'],
          gender: responseData['user']['gender'],
        );

        // Login user
        UserProvider userProvider =
            Provider.of<UserProvider>(context, listen: false);
        userProvider.login(user);

        // Navigate to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        // Handle error
        final errorMessage =
            json.decode(response.body)['message'] ?? 'Login failed';
        showError(errorMessage);
      }
    } catch (error) {
      // Check if the widget is still mounted before calling setState
      if (!mounted) return;

      setState(() {
        _isLoading = false; // Hide loading indicator on error
      });
      showError('Error during login');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed:
                  _isLoading ? null : loginUser, // Disable button while loading
              child: _isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
