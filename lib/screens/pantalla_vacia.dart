import 'package:flutter/material.dart';

class PantallaVacia extends StatelessWidget {
  const PantallaVacia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Vacia'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 160, vertical: 200),
                textStyle: const TextStyle(fontSize: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              onPressed: () {
                // Acción del primer botón
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Botón 1 presionado')),
                );
              },
              child: const Text('Botón 1'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 160, vertical: 100),
                textStyle: const TextStyle(fontSize: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              onPressed: () {
                // Acción del segundo botón
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Botón 2 presionado')),
                );
              },
              child: const Text('Botón 2'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PantallaVacia(),
  ));
}
