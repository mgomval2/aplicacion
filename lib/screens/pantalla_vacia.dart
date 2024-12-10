import 'package:flutter/material.dart';
import 'minijuego.dart'; // Importa la nueva pantalla para el juego
import 'explorardatos.dart'; // Importa la pantalla de explorar datos

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Recuadro del título
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 206, 211, 230), // Fondo del recuadro
                  borderRadius: BorderRadius.circular(15), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Posición de la sombra
                    ),
                  ],
                ),
                child: const Text(
                  'BIBLIOTECA DE CONOCIMIENTOS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 40), // Espacio entre el título y los botones
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCustomButton(
                      context,
                      'Explorar Datos',
                      'assets/icono_explorar.jpg', // Reemplaza con tu imagen
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PantallaExplorarDatos()),
                        );
                      },
                    ),
                    _buildCustomButton(
                      context,
                      'Juego: El dato perdido',
                      'assets/juego_icono.png', // Reemplaza con tu imagen
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PantallaMinijuego()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, String text, String imagePath, VoidCallback onPressed) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4, // Ajusta el tamaño
      height: MediaQuery.of(context).size.height * 0.25,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(0),
          backgroundColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Stack(
          children: [
            // Imagen de marca de agua
            Positioned.fill(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Texto centrado
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
    debugShowCheckedModeBanner: false,
  ));
}
