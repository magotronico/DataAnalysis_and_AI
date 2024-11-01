import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_nav_bar.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String username = 'admin'; // Default username

  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Hola $username!"),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  Widget _getBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return SearchScreen();
      case 2:
        _handleLogout(context); // Trigger logout when this tab is selected
        return _buildHomeContent(); // This will be shown briefly before navigation
      default:
        return _buildHomeContent();
    }
  }

  void _onTabTapped(int index) {
    if (index == 2) {
      // If logout tab is tapped, handle logout
      _handleLogout(context);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/dimex_white.png',
          height: 40,
        ),
        centerTitle: false,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeContent(),
          SearchScreen(),
          Container(), // Empty container for logout tab since it's just an action
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}