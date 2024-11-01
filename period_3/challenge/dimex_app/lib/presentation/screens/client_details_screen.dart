import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientDetailsScreen extends StatelessWidget {
  final String clientId = 'C0080';

  Future<Map<String, dynamic>> fetchClientDetails() async {
    final response = await http.get(Uri.parse("http://127.0.0.1:8000/client/$clientId"));
    
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchClientDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No client details found.'));
          }

          // Extract client details
          final client = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
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
                      backgroundColor: Colors.grey[300], // Placeholder background
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[600], // Placeholder icon color
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Client ID: ${client['id_cliente']}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
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
      ),
    );
  }
}
