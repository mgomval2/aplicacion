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
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Puntuación: $_puntuacion",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Dato ${_indiceActual + 1} de ${_datosCuriosos.length}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      _datosCuriosos[_indiceActual]['dato']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Ingresa la palabra faltante',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _verificarRespuesta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Comprobar Respuesta', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _mostrarPista,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Pista', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _cambiarDato,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Siguiente Dato', style: TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _retroalimentacion,
                    style: TextStyle(
                      fontSize: 16,
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