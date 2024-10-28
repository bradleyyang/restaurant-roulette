import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class User {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String gender;

  User({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
  });
}

class UserProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void login(User user) {
    _currentUser = user;
    notifyListeners(); // Notify listeners to rebuild widgets
  }

  void logout() {
    _currentUser = null;
    notifyListeners(); // Notify listeners to rebuild widgets
  }
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
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

// Login Page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> loginUser() async {
    final String apiUrl =
        'http://10.0.2.2:3000/api/auth/login'; // Update with your API URL

    final Map<String, String> userData = {
      'username': _usernameController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        // Login successful
        // Assuming _usernameController is defined
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
      showError('Error during login');
    }
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
              onPressed: loginUser,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user from the UserProvider
    final currentUser = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              UserProvider().logout(); // Clear user on logout
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${currentUser?.username ?? 'Guest'}!', // Display username
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Here you can find your personalized content and features.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Text('View Profile'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to another feature (e.g., restaurant recommendations)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Restaurant recommendations coming soon!')),
                );
              },
              child: Text('View Restaurant Recommendations'),
            ),
            // You can add more features or buttons as needed
          ],
        ),
      ),
    );
  }
}

// Profile page

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${currentUser?.username ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('First Name: ${currentUser?.firstName ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Last Name: ${currentUser?.lastName ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Email: ${currentUser?.email ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Phone Number: ${currentUser?.phoneNumber ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Gender: ${currentUser?.gender ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
