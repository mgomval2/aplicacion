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

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
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
    } catch (e) {
      print("Error al cargar el archivo JSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categorias = datosCuriosos.keys.toList();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorar Datos'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: datosCuriosos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Fondo con degradado suave
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFE3F2FD), // Azul muy claro
                        Color(0xFFFCE4EC), // Rosa pastel claro
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // Bola del mundo en el centro
                Positioned(
                  top: screenHeight * 0.25,
                  left: screenWidth / 2 - 130,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * 3.141592653589793,
                        child: child,
                      );
                    },
                    child: CircleAvatar(
                      radius: 130, // Tamaño aumentado
                      backgroundImage: AssetImage('assets/globo_del_mundo.jpg'),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                // Botones del lado izquierdo
                Positioned(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryButton(context, categorias[0]),
                      SizedBox(height: screenHeight * 0.1),
                      _buildCategoryButton(context, categorias[1]),
                      SizedBox(height: screenHeight * 0.1),
                      _buildCategoryButton(context, categorias[2]),
                    ],
                  ),
                ),
                // Botones del lado derecho
                Positioned(
                  right: screenWidth * 0.1,
                  top: screenHeight * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCategoryButton(context, categorias[3]),
                      SizedBox(height: screenHeight * 0.1),
                      _buildCategoryButton(context, categorias[4]),
                      SizedBox(height: screenHeight * 0.1),
                      _buildCategoryButton(context, categorias[5]),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20), // Botones más largos
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        side: const BorderSide(color: Colors.deepPurpleAccent, width: 1.5),
      ),
      onPressed: () {
        _mostrarDatoCurioso(context, category);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lightbulb_outline, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Text(
            category,
            style: const TextStyle(color: Colors.deepPurple),
          ),
        ],
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
              backgroundColor: Colors.deepPurple.shade50,
              title: Text(
                'Dato Curioso: $category',
                style: const TextStyle(color: Colors.deepPurple),
              ),
              content: Text(
                datosCuriosos[category]![currentIndex],
                style: const TextStyle(color: Colors.black87),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
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
