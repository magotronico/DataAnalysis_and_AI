import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatbot_screen.dart';
import 'search_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String username = 'Usuario';
  int clientesPorAtenderCount = 0;


  @override
  void initState() {
    super.initState();
    _fetchAndSetUsername();
  }

  Future<void> _fetchAndSetUsername() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? storedIp = prefs.getString('serverIp');
      if (storedIp == null) {
        throw Exception('No IP stored in preferences.');
      }
      final details = await fetchClientDetails(storedIp); // Fetch details from API
      print(details);

      setState(() {
        username = details['nombre_completo'] ?? 'NoName0'; // Set the username
        // Count the number of clientes_por_atender
        final List<String> clientesPorAtender = (details['clientes_por_atender'] is String)
            ? (jsonDecode(details['clientes_por_atender']) as List<dynamic>)
                .map((item) => item.toString())
                .toList()
            : (details['clientes_por_atender'] as List<dynamic>?)
                ?.map((item) => item.toString())
                .toList() ?? [];

        clientesPorAtenderCount = clientesPorAtender.length; // Set the count
      });
    } catch (error) {
      setState(() {
        username = 'NoName'; // Fallback if there's an error.
        clientesPorAtenderCount = 0; // Reset count on error
        print(error);
      });
    }
  }


  final List<Map<String, dynamic>> clients = [
    {'name': 'Client A', 'importance': 'High'},
    {'name': 'Client B', 'importance': 'Medium'},
    {'name': 'Client C', 'importance': 'Low'},
  ];

  final int remainingClients = 20;

  Future<Map<String, dynamic>> fetchClientDetails(String storedIp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final response = await http.get(Uri.parse("http://$storedIp:8000/usuario/$userId"));

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Hubo un error al cargar los detalles del usuario.');
    }
  }

  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hola $username!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1, // Adjust the flex if needed for proportions
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _buildPieChart(), // Call the pie chart widget
                ),
              ),
              SizedBox(width: 16), // Spacing between the two sections
              Expanded(
                flex: 1, // Equal space as the pie chart
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person, size: 50),
                      SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pendientes",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "${clientesPorAtenderCount}",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            "Clientes Asignados",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                Color color;
                switch (client['importance']) {
                  case 'High':
                    color = Colors.red[300]!;
                    break;
                  case 'Medium':
                    color = Colors.orange[300]!;
                    break;
                  case 'Low':
                    color = Colors.green[300]!;
                    break;
                  default:
                    color = Colors.grey[300]!;
                }
                return Card(
                  color: color,
                  child: ListTile(
                    title: Text(client['name']),
                    subtitle: Text("Importance: ${client['importance']}"),
                  ),
                );
              },
            ),
          ),
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

  void _onTabTapped(int index) {
    if (index == 3) {
      _handleLogout(context);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 60,
            color: Colors.blue,
            title: '60%',
            radius: 50,
          ),
          PieChartSectionData(
            value: 40,
            color: Colors.orange,
            title: '40%',
            radius: 50,
          ),
        ],
      ),
    );
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
          _buildHomeContent(), // Index 0
          SearchScreen(),       // Index 1
          ChatBot(),            // Index 2
          Container(),          // Placeholder for logout
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
