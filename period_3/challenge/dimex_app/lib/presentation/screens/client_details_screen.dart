import 'package:dimex_app/presentation/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_interaction_screen.dart';

class ClientDetailsScreen extends StatelessWidget {
  final String clientId;

  ClientDetailsScreen({required this.clientId});

  Future<String> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('serverIp') ?? '';
  }

  double _calculatePercentage(dynamic numerator, dynamic denominator) {
    if (numerator == null || denominator == null || denominator == 0) {
      return 0.0;
    }

    // Convert numeric strings to double if needed
    double numValue = (numerator is String) ? double.tryParse(numerator) ?? 0.0 : numerator.toDouble();
    double denomValue = (denominator is String) ? double.tryParse(denominator) ?? 0.0 : denominator.toDouble();

    if (denomValue == 0) {
      return 0.0; // Avoid division by zero
    }

    // Calculate percentage and round to 2 decimal places
    double percentage = (numValue / denomValue) * 100;
    return double.parse(percentage.toStringAsFixed(2));
  }

  int _calculateTotalContacts(dynamic callCenter, dynamic puertaPuerta, dynamic agenciasEspecializadas) {
    // Convert numeric strings to int if needed
    int callCenterValue = (callCenter is String) ? int.tryParse(callCenter) ?? 0 : callCenter.toInt();
    int puertaPuertaValue = (puertaPuerta is String) ? int.tryParse(puertaPuerta) ?? 0 : puertaPuerta.toInt();
    int agenciasEspecializadasValue = (agenciasEspecializadas is String) 
        ? int.tryParse(agenciasEspecializadas) ?? 0 
        : agenciasEspecializadas.toInt();

    // Calculate total contacts
    int totalContacts = callCenterValue + puertaPuertaValue + agenciasEspecializadasValue;

    return totalContacts;
  }




  Future<Map<String, dynamic>> fetchClientDetails(String storedIp) async {
    final response = await http.get(Uri.parse("http://$storedIp:8000/client/$clientId"));

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Hubo un error al cargar los detalles del cliente.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Cliente'),
      ),
      body: FutureBuilder<String>(
        future: _loadCredentials(),
        builder: (context, ipSnapshot) {
          if (ipSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (ipSnapshot.hasError) {
            return Center(child: Text('Error cargando el IP: ${ipSnapshot.error}'));
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
                return Center(child: Text('No se encontraron detalles del cliente.'));
              }

              final client = clientSnapshot.data!;

              // Calculate percentages
              double ccPercentage = _calculatePercentage(
                client['call_center_atendido'],
                client['gestion_Call Center'],
              );
              double ppPercentage = _calculatePercentage(
                client['puerta_a_puerta_atendido'],
                client['gestion_Gestion Puerta a Puerta'],
              );
              double aePercentage = _calculatePercentage(
                client['agencias_especializadas_atendido'],
                client['gestion_Agencias Especializadas'],
              );

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Card(
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
                              backgroundImage: AssetImage('assets/fotos_clientes/imagen_${client['id_foto']}.webp'),
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(height: 20),

                            // Contacto Card
                            Card(
                              color: Theme.of(context).colorScheme.secondary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                width: cardWidth,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contacto',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text('Número de Cliente: ${client['id_cliente']}'),
                                    Text('Nombre: ${client['nombre_completo']}'),
                                    Text('Correo: ${client['correo']}'),
                                    Text('Teléfono: ${client['telefono']}'),
                                    Text('Dirección: ${client['direccion']}'),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Propuesta Card
                            Card(
                              color: Theme.of(context).colorScheme.secondary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Container(
                                width: cardWidth,
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recomendación Siguiente Interacción',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text('Vía de Contacto: ${client['mejorGestion'] ?? 'No information'}'),
                                    Text('Propuesta: ${client['mejorOferta'] ?? 'No information'}'),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Historial collapsible card
                            ExpansionTile(
                              title: Text(
                                      'Historial',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                                    // borderRadius: BorderRadius.circular(8),
                                    // border: Border.all(color: Colors.grey),
                              children: [
                                Container(
                                  width: cardWidth,
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Tasa de Interés: ${client['tasa interes'] ?? 'No information'}%'),
                                      Text('Plazo de Meses: ${client['Plazo_Meses'] ?? 'No information'}'),
                                      Text('Línea de Crédito: \$${client['Linea credito'] ?? 'No information'}'),
                                      PaymentCapacityWidget(
                                        capacidadPago: client['capacidad_pago'],
                                        pagoMensual: client['Pago'],
                                      ),
                                      Text('Última Gestión: ${client['ultimaGestion'] ?? 'No information'}'),
                                      Text('Cantidad de Interacciones: ${_calculateTotalContacts(client['gestion_Agencias Especializadas'], client['gestion_Call Center'], client['gestion_Gestion Puerta a Puerta'])}'),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(child: _buildPercentageCard('CC', ccPercentage)),
                                          SizedBox(width: 10),
                                          Expanded(child: _buildPercentageCard('PP', ppPercentage)),
                                          SizedBox(width: 10),
                                          Expanded(child: _buildPercentageCard('AE', aePercentage)),
                                        ],
                                      ),
                                      Text('** Tipo de Gestion. CC: Call Center, PP: Puerta en Puerta, AE: Agente Externo', style: TextStyle(fontSize: 9)),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            // Button for new interaction
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewInteractionScreen(clientId: client['id_cliente']),
                                  ),
                                );
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
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPercentageCard(String label, dynamic value) {
    return Card(
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${value ?? '0'}%', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
