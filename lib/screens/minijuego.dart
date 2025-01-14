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
      });
      _mostrarVentanaEmergente("¡Correcto! 🎉", "Has acertado la respuesta.");
    } else {
      _mostrarVentanaEmergente(
          "Intenta de nuevo 😅", "La respuesta no es correcta. ¡Inténtalo nuevamente!");
    }
  }

  void _mostrarPista() {
    String respuesta = _datosCuriosos[_indiceActual]['respuesta']!;
    _mostrarVentanaEmergente("Pista", "La palabra comienza con: ${respuesta[0]}");
  }

  void _cambiarDato() {
    if (_indiceActual + 1 == _datosCuriosos.length) {
      setState(() {
         _mostrarVentanaEmergente(
          "Juego terminado 🎉", "¡Has completado el juego! Tu puntuación es $_puntuacion.");
      });
      return;
    }
    setState(() {
      _indiceActual++;
      _retroalimentacion = "";
      _controller.clear();
    });
  }


  


  void _mostrarVentanaEmergente(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            titulo,
            style: TextStyle(
              color: titulo.contains("Correcto") ? Colors.green : Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            mensaje,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cerrar",
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ],
        );
      },
    );
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
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
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Dato ${_indiceActual + 1} de ${_datosCuriosos.length}",
                              style: const TextStyle(
                                fontSize: 12,
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
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
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
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ElevatedButton(
                          onPressed: _verificarRespuesta,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 160, 115, 236),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Comprobar Respuesta', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ElevatedButton(
                          onPressed: _mostrarPista,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Pista', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ElevatedButton(
                          onPressed: _cambiarDato,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 218, 123, 234),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Siguiente Dato', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _retroalimentacion,
                    style: TextStyle(
                      fontSize: 14,
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
