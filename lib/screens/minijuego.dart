import 'package:flutter/material.dart';

class PantallaMinijuego extends StatefulWidget {
  const PantallaMinijuego({Key? key}) : super(key: key);

  @override
  _PantallaMinijuegoState createState() => _PantallaMinijuegoState();
}

class _PantallaMinijuegoState extends State<PantallaMinijuego> {
  final TextEditingController _controller = TextEditingController();
  final String _datoCurioso = "El _ fue el primer hombre en pisar la Luna.";
  final String _respuestaCorrecta = "hombre";

  String _retroalimentacion = "";

  void _verificarRespuesta() {
    if (_controller.text.toLowerCase() == _respuestaCorrecta.toLowerCase()) {
      setState(() {
        _retroalimentacion = "¡Correcto! 🎉";
      });
    } else {
      setState(() {
        _retroalimentacion = "Intenta de nuevo 😅";
      });
    }
  }

  void _mostrarPista() {
    setState(() {
      _retroalimentacion = "Pista: Empieza con 'h'.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minijuego: El dato perdido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _datoCurioso,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingresa la palabra faltante',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verificarRespuesta,
              child: const Text('Comprobar Respuesta'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _mostrarPista,
              child: const Text('Pista'),
            ),
            const SizedBox(height: 20),
            Text(
              _retroalimentacion,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _retroalimentacion == "¡Correcto! 🎉"
                    ? Colors.green
                    : Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
