import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ClientDetailsScreen extends StatelessWidget {
  final String clientId;

  ClientDetailsScreen({required this.clientId});

  // Load the stored IP address from shared preferences
  Future<String> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('serverIp') ?? '';
  }

  Future<Map<String, dynamic>> fetchClientDetails(String storedIp) async {
    final response = await http.get(Uri.parse("http://$storedIp:8000/client/$clientId"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load client details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Details'),
      ),
      body: FutureBuilder<String>(
        future: _loadCredentials(),
        builder: (context, ipSnapshot) {
          if (ipSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (ipSnapshot.hasError) {
            return Center(child: Text('Error loading IP: ${ipSnapshot.error}'));
          }

          final storedIp = ipSnapshot.data!;
          return FutureBuilder<Map<String, dynamic>>(
            future: fetchClientDetails(storedIp),
            builder: (context, clientSnapshot) {
              if (clientSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (clientSnapshot.hasError) {
                return Center(child: Text('Error: ${clientSnapshot.error}'));
              } else if (!clientSnapshot.hasData || clientSnapshot.data!.isEmpty) {
                return Center(child: Text('No client details found.'));
              }

              final client = clientSnapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Theme.of(context).cardColor,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Name: ${client['nombre_completo']}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Email: ${client['correo']}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Phone: ${client['telefono']}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Address: ${client['direccion']}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Last Contact: ${client['ultimo_contacto']}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Contact Type: ${client['tipo_contacto']}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to another screen when implemented
                          },
                          child: Text('Nueva Interacción'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
