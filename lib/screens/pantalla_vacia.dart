import 'package:flutter/material.dart';

class PantallaVacia extends StatelessWidget {
  const PantallaVacia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Vacia'),
      ),
      body: const Center(
        child: Text(
          'Esta es una pantalla vacia.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
