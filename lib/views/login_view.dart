// Importación de paquetes y archivos necesarios
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../pages/home_page.dart';
import '../services/token_storage.dart'; // Importa TokenStorage

// Clase que define la vista de inicio de sesión
class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTEM Login'), // Título de la barra de aplicación
      ),
      body: Stack(
        children: <Widget>[
          // Fondo de la pantalla de inicio de sesión
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromRGBO(44, 173, 173, 1),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50), // Ajuste de la posición superior

                // Tarjeta de presentación de la aplicación
                Card(
                  elevation: 4,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(186, 240, 240, 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Booking UTEM\nZeta', // Texto de presentación de la aplicación
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inknut Antiqua',
                        fontSize: 24,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Espacio entre la tarjeta y el logo

                // Logo de la aplicación
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/utemblanco1.png'), // Ruta de la imagen del logo
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30), // Espacio antes del botón

                // Botón de inicio de sesión con Google
                SizedBox(
                  width: 250, // Ancho del botón
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Acción al presionar el botón de inicio de sesión
                      // Implementa tu lógica aquí para iniciar sesión
                      _handleSignIn(
                          context); // Método para manejar el inicio de sesión
                    },
                    icon: Icon(
                        Icons.login), // Icono de Google para iniciar sesión
                    label: Text('Iniciar Sesión con Google'), // Texto del botón
                  ),
                ),
                SizedBox(height: 20), // Espacio después del botón

                Expanded(
                  child:
                      SizedBox(), // Añadir espacio para colocar en la parte inferior
                ),

                // Textos inferiores (Versión y Derechos Reservados)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'v.1.1.0', // Versión de la aplicación
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Imprima',
                          fontSize: 24,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                      Text(
                        'All Right Reserved', // Derechos Reservados
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontFamily: 'Imprima',
                          fontSize: 24,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para manejar el inicio de sesión con Google
  Future<void> _handleSignIn(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

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
              builder: (context) =>
                  HomePage(), // Navegar a la pantalla principal
            ),
          );
        } else {
          print(
              'El token de sesión es nulo.'); // Mensaje de consola (solo para pruebas)
        }
      } else {
        print(
            'Inicio de sesión cancelado.'); // Mensaje de consola (solo para pruebas)
      }
    } catch (error) {
      print(
          'Error al iniciar sesión: $error'); // Mensaje de consola en caso de error
    }
  }
}
