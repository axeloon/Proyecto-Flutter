import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_flutter/views/home_view.dart';
import '../pages/login_page.dart';
import '../pages/rooms_page.dart';

class HomePage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      print('Cierre de sesión exitoso');
      // Redirigir al usuario a la página de inicio de sesión después del cierre de sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Stack(
        children: [
          HomeView(), // Aquí integras el widget generado
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _handleSignOut(context),
            ),
          ),
        ],
      ),
    );
  }
}
