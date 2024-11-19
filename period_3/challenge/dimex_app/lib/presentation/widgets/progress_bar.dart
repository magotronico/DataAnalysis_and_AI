import 'package:flutter/material.dart';

class PaymentCapacityWidget extends StatelessWidget {
  final dynamic capacidadPago; // Can be a string or a double
  final dynamic pagoMensual; // Can be a string or a double

  PaymentCapacityWidget({required this.capacidadPago, required this.pagoMensual});

  double _parseToDouble(dynamic value) {
    if (value is String) {
      // Remove commas and parse the string to a double
      String sanitizedValue = value.replaceAll(',', '');
      return double.tryParse(sanitizedValue) ?? 0.0;
    } else if (value is double) {
      return value;
    } else {
      return 0.0; // Default to 0 if the input is invalid
    }
  }

  @override
  Widget build(BuildContext context) {
    // Convert inputs to double
    double capacidadPagoValue = _parseToDouble(capacidadPago);
    double pagoMensualValue = _parseToDouble(pagoMensual);

    // Calculate progress
    double progress = (pagoMensualValue == 0) ? 0 : capacidadPagoValue / pagoMensualValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado Financiero del Cliente',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 10),

        // Dynamically decide layout for Capacidad de Pago and Pago Mensual
        LayoutBuilder(
          builder: (context, constraints) {
            // Threshold width for determining single-line or multi-line display
            double thresholdWidth = 1080; // Adjust this based on design
            bool shouldWrap = constraints.maxWidth < thresholdWidth;

            if (shouldWrap) {
              // Use a Column to stack the texts
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Capacidad de Pago: \$${capacidadPagoValue.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Pago Mensual: \$${pagoMensualValue.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              );
            } else {
              // Use a Row to display texts side by side
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Capacidad de Pago: \$${capacidadPagoValue.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Pago Mensual: \$${pagoMensualValue.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }
          },
        ),
        SizedBox(height: 10),

        // Progress bar with responsiveness
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 15,
                  width: constraints.maxWidth, // Use available width
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Container(
                  height: 15,
                  width: constraints.maxWidth * progress.clamp(0.0, 1.0), // Scale by progress
                  decoration: BoxDecoration(
                    color: (progress >= 1.0) ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 5),

        // Text indicating financial status
        Text(
          progress >= 1.0
              ? 'Cliente está en buen estado financiero.'
              : 'Cliente está en riesgo financiero.',
          style: TextStyle(
            color: (progress >= 1.0) ? const Color.fromARGB(255, 27, 83, 29) : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
