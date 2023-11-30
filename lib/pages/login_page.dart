import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/home_page.dart';
import '../services/token_storage.dart'; // Importa TokenStorage

class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String? idToken = googleAuth.idToken;
        TokenStorage.setToken(idToken); // Almacena el token

        if (idToken != null) {
          // Mostrar la lista de salas en la pantalla Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          print('El token de sesión es nulo.');
          // Aquí puedes manejar el caso cuando el token de sesión es nulo
        }
      } else {
        print('Inicio de sesión cancelado.');
      }
    } catch (error) {
      print('Error al iniciar sesión: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UTEM Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(context),
          child: Text('Iniciar Sesión con Google'),
        ),
      ),
    );
  }
}