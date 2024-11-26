import 'package:flutter/material.dart';
import 'screens/pantalla_login.dart'; 

void main() {
  runApp(MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplicacion de Inicio de Sesion',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: PantallaLogin(), 
    );
  }
}
