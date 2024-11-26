import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  bool _obscureText = true; // To toggle password visibility
  String? _errorMessage;
  bool _isIpVisible = false; // Track IP input visibility

  @override
  void initState() {
    super.initState();
    _loadCredentials(); // Load IP and username from shared preferences
  }

  // Load the stored IP address and username from shared preferences
  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedIp = prefs.getString('serverIp');

    if (storedIp != null) {
      _ipController.text = storedIp;
    }
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String serverIp = _ipController.text; // Get the IP from the input

    // Validate the IP address input
    if (serverIp.isEmpty) {
      _showErrorSnackbar('Please enter a server IP address.');
      return;
    }

    // Save the IP address to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('serverIp', serverIp);

    // Construct the API URL using the inputted IP
    // final String url = 'http://$storedIp:8000/login/'; // Use this if you are using a local server
    final String url = 'https://dimex-api.azurewebsites.net/login/'; // Use this if you are using the Azure server

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json", // Set content type to JSON
        },
        body: json.encode({
          'id': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = json.decode(response.body);
        final String userId = responseBody['user_id'];

        // Save the user ID to shared preferences
        await prefs.setString('userId', userId);

        // Save the login state
        await prefs.setBool('isLoggedIn', true);

        // Login successful, navigate to HomeScreen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Handle the case where the login failed
        setState(() {
          _errorMessage = json.decode(response.body)['detail'] ?? 'Login failed. Please try again.';
        });
        _showErrorSnackbar(_errorMessage!);
      }
    } catch (e) {
      // Handle any exceptions here
      _showErrorSnackbar('An error occurred. Please try again.');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de sesión'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: Theme.of(context).cardColor,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/dimex_green.png', // Add your logo image here
                    height: 150,
                  ),
                  // SizedBox(height: 20),
                  // if (_isIpVisible) // Show IP input field based on visibility
                  //   TextField(
                  //     controller: _ipController, // Controller for IP address input
                  //     decoration: InputDecoration(
                  //       labelText: 'Server IP Address',
                  //     ),
                  //   ),
                  // SizedBox(height: 20),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _isIpVisible = !_isIpVisible; // Toggle visibility of IP input
                  //     });
                  //   },
                  //   child: Text(_isIpVisible ? 'Hide IP Input' : 'Show IP Input'),
                  // ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'ID or Email',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText; // Toggle password visibility
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  if (_errorMessage != null) // Display error message if available
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ), 
            ),
          ),          
        ),
      ),
    );
  }
}
