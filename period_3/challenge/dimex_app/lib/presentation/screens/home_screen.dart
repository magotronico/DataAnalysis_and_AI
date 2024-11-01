import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: Text('Search Clients'),
            ),
            ElevatedButton(
              onPressed: () async {
  // Log off and navigate back to the LoginScreen
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false); // Reset login state
  
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/login',
    (Route<dynamic> route) => false, // Clears navigation stack
  );
},

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: Text('Log Off', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
