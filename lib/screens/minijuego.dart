import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PantallaMinijuego extends StatefulWidget {
  const PantallaMinijuego({Key? key}) : super(key: key);

  @override
  _PantallaMinijuegoState createState() => _PantallaMinijuegoState();
}

class _PantallaMinijuegoState extends State<PantallaMinijuego> {
  final TextEditingController _controller = TextEditingController();

  List<Map<String, String>> _datosCuriosos = [];
  int _indiceActual = 0;
  int _puntuacion = 0;
  String _retroalimentacion = "";
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final String response =
          await rootBundle.loadString('assets/datos_curiosos.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _datosCuriosos = data
            .map((e) => {
                  "dato": e["dato"] as String,
                  "respuesta": e["respuesta"] as String,
                })
            .toList();
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _retroalimentacion = "Error al cargar los datos: $e";
        _cargando = false;
      });
    }
  }

  void _verificarRespuesta() {
    String respuestaCorrecta = _datosCuriosos[_indiceActual]['respuesta']!;
    if (_controller.text.toLowerCase() == respuestaCorrecta.toLowerCase()) {
      setState(() {
        _puntuacion++;
        _retroalimentacion = "¡Correcto! 🎉";
      });
    } else {
      setState(() {
        _retroalimentacion = "Intenta de nuevo 😅";
      });
    }
  }

  void _mostrarPista() {
    String respuesta = _datosCuriosos[_indiceActual]['respuesta']!;
    setState(() {
      _retroalimentacion = "Pista: ${respuesta[0]}${'_' * (respuesta.length - 1)}";
    });
  }

  void _cambiarDato() {
    if (_indiceActual + 1 == _datosCuriosos.length) {
      setState(() {
        _retroalimentacion = "¡Juego terminado! 🎉 Puntuación: $_puntuacion";
      });
      return;
    }
    setState(() {
      _indiceActual++;
      _retroalimentacion = "";
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minijuego: El dato perdido'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Puntuacion: $_puntuacion",
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Dato ${_indiceActual + 1} de ${_datosCuriosos.length}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _datosCuriosos[_indiceActual]['dato']!,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _cambiarDato,
                    child: const Text('Siguiente Dato'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _retroalimentacion,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _retroalimentacion.contains("Correcto")
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
