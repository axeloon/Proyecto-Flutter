import 'package:flutter/material.dart';
import '/pages/login_page.dart'; // Importa la LoginPage desde su ubicación

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuración de la aplicación
      debugShowCheckedModeBanner: false, // Oculta el banner de depuración

      // Título de la aplicación que se muestra en la barra del dispositivo
      title: 'UTEM Login',

      // Configuración visual de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Color principal: azul
      ),

      // Página de inicio de la aplicación
      home: LoginPage(), // Establece la página de inicio como LoginPage
    );
  }
}
