import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class PantallaExplorarDatos extends StatefulWidget {
  const PantallaExplorarDatos({Key? key}) : super(key: key);

  @override
  _PantallaExplorarDatosState createState() => _PantallaExplorarDatosState();
}

class _PantallaExplorarDatosState extends State<PantallaExplorarDatos>
    with SingleTickerProviderStateMixin {
  late Map<String, List<String>> datosCuriosos = {};
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _cargarDatos();

    // Configurar el AnimationController para rotar la imagen continuamente
    _controller = AnimationController(
      duration: const Duration(seconds: 20), // Tiempo para completar una rotación
      vsync: this,
    )..repeat(); // Repetir la animación indefinidamente
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberar el AnimationController cuando se destruya el widget
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    try {
      final String response =
          await rootBundle.loadString('assets/datos_explorar.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        datosCuriosos = (data['categorias'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            List<String>.from(value as List),
          ),
        );
      });

      print("Datos procesados correctamente: $datosCuriosos");
    } catch (e) {
      print("Error al cargar el archivo JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Datos'),
      ),
      body: datosCuriosos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Bola del mundo giratoria en el centro
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * 3.141592653589793, // Rotación en radianes
                        child: child,
                      );
                    },
                    child: CircleAvatar(
                      radius: 130,
                      backgroundImage: AssetImage('assets/globo_del_mundo.jpg'),
                    ),
                  ),
                ),
                // Botones de categorías
                _crearBotones(context),
              ],
            ),
    );
  }

  Widget _crearBotones(BuildContext context) {
  final categories = datosCuriosos.keys.toList();
  return Stack(
    children: [
      Align(
        alignment: const Alignment(-0.8, -0.5), // Botón superior izquierdo
        child: _buildCategoryButton(context, categories[0]),
      ),
      Align(
        alignment: const Alignment(0.8, -0.5), // Botón superior derecho
        child: _buildCategoryButton(context, categories[1]),
      ),
      Align(
        alignment: const Alignment(-0.8, 0.5), // Botón inferior izquierdo
        child: _buildCategoryButton(context, categories[2]),
      ),
      Align(
        alignment: const Alignment(0.8, 0.5), // Botón inferior derecho
        child: _buildCategoryButton(context, categories[3]),
      ),
      Align(
        alignment: const Alignment(-0.4, 0.0), // Botón medio izquierdo
        child: _buildCategoryButton(context, categories[4]),
      ),
      Align(
        alignment: const Alignment(0.4, 0.0), // Botón medio derecho
        child: _buildCategoryButton(context, categories[5]),
      ),
    ],
  );
}


  Widget _buildCategoryButton(BuildContext context, String category) {
    return SizedBox(
      width: 160,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          backgroundColor: Colors.purple.shade100,
          shadowColor: Colors.purple,
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {
          _mostrarDatoCurioso(context, category);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, color: Colors.purple.shade700),
            const SizedBox(width: 10),
            Text(category),
          ],
        ),
      ),
    );
  }

  void _mostrarDatoCurioso(BuildContext context, String category) {
    int currentIndex = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Dato Curioso: $category'),
              content: Text(datosCuriosos[category]![currentIndex]),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      currentIndex =
                          (currentIndex + 1) % datosCuriosos[category]!.length;
                    });
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
