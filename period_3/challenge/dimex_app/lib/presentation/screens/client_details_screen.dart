import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Client Details')),
      body: Center(
        child: Text('Details of the selected client will be displayed here.'),
      ),
    );
  }
}
