import 'package:flutter/material.dart';
import 'minijuego.dart'; // Importa la nueva pantalla para el juego

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biblioteca de Conocimientos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                // Navega a la pantalla de Explorar Datos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Placeholder()), // Cambia Placeholder() por tu pantalla de explorar datos cuando esté lista
                );
              },
              child: const Text('Explorar Datos'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                // Navega a la pantalla del minijuego
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PantallaMinijuego()),
                );
              },
              child: const Text('Juego: El dato perdido'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PantallaPrincipal(),
  ));
}
