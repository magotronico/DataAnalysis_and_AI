import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class NewInteractionScreen extends StatefulWidget {
  final String clientId;

  NewInteractionScreen({required this.clientId});

  @override
  _NewInteractionScreenState createState() => _NewInteractionScreenState();
}

class _NewInteractionScreenState extends State<NewInteractionScreen> {
  final TextEditingController _interactionDetailsController = TextEditingController();
  final TextEditingController _agreementController = TextEditingController();
  final TextEditingController _nextPaymentDateController = TextEditingController();
  final TextEditingController _collectionOfferController = TextEditingController();
  String _contactMethod = '1'; // Default contact method

  Future<String> _loadServerIp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('serverIp') ?? '';
  }

  Future<void> _submitInteraction() async {
    final String serverIp = await _loadServerIp();
    if (serverIp.isEmpty) {
      _showSnackbar('Server IP is not configured.');
      return;
    }

    final String interactionDetails = _interactionDetailsController.text;
    final String agreement = _agreementController.text;
    final String nextPaymentDate = _nextPaymentDateController.text;
    final String collectionOffer = _collectionOfferController.text;

    if (interactionDetails.isEmpty || agreement.isEmpty || nextPaymentDate.isEmpty || collectionOffer.isEmpty) {
      _showSnackbar('Please fill in all fields.');
      return;
    }

    final String url = 'http://$serverIp:8000/nueva_interaccion';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');

    final String interactionId = 'I${DateTime.now().millisecondsSinceEpoch}'; // Generate unique interaction ID
    final String createdAt = DateFormat('hh:mm:ss a').format(DateTime.now()); // Current time in the required format

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'id_interaccion': interactionId,
          'created_at': createdAt,
          'id_cliente': widget.clientId,
          'id_usuario': userId,
          'via_contacto': _contactMethod,
          'interaccion': interactionDetails,
          'acuerdo': agreement,
          'fecha_prox_pago': nextPaymentDate,
          'oferta_cobranza': collectionOffer,
          'oferta_cobranza_modelo': '0', // Placeholder value
          'via_contacto_modelo': '0', // Placeholder value
        }),
      );

      if (response.statusCode == 200) {
        _showSnackbar('Interaction successfully recorded.');
        Navigator.pop(context);
      } else {
        _showSnackbar('Failed to record interaction: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showSnackbar('An error occurred: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Interaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Interaction Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _interactionDetailsController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Describe the interaction...'
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _agreementController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Agreement',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nextPaymentDateController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Next Payment Date (e.g., 7/11/2024)',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _collectionOfferController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Collection Offer',
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _contactMethod,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contact Method',
              ),
              items: [
                DropdownMenuItem(
                  value: '1',
                  child: Text('Method 1'),
                ),
                DropdownMenuItem(
                  value: '2',
                  child: Text('Method 2'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _contactMethod = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitInteraction,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
