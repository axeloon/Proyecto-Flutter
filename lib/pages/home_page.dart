import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_flutter/views/home_view.dart'; // Importa la vista de inicio
import 'package:url_launcher/url_launcher.dart'; // Importa el paquete para el lanzamiento de URL
import '../pages/login_page.dart'; // Importa la página de inicio de sesión

// Clase StatelessWidget para la página principal
class HomePage extends StatelessWidget {
  final GoogleSignIn _googleSignIn =
      GoogleSignIn(); // Instancia de GoogleSignIn

  // Método para cerrar sesión y redirigir al usuario a la página de inicio de sesión
  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // Cierre de sesión con Google
      print('Cierre de sesión exitoso');
      Navigator.pushReplacement(
        // Redirección a la página de inicio de sesión
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (error) {
      print('Error al cerrar sesión: $error');
    }
  }

  // Método para mostrar información de la aplicación en un diálogo
  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Información de la App'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'App creada por el grupo zeta\n\nRepositorio:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  child: Text(
                    'https://github.com/axeloon/Proyecto-Flutter', // URL del repositorio
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () async {
                    const url = 'https://github.com/axeloon/Proyecto-Flutter';
                    if (await canLaunch(url)) {
                      // Verificar si se puede lanzar la URL
                      await launch(url); // Lanzar la URL en el navegador
                    } else {
                      final fallbackUrl =
                          'http://github.com/axeloon/Proyecto-Flutter';
                      if (await canLaunch(fallbackUrl)) {
                        // Si no se puede lanzar, intentar con otra URL
                        await launch(fallbackUrl);
                      } else {
                        throw 'No se pudo abrir el enlace $url'; // Manejo de errores
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
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
        title: Text('Booking UTEM v1'), // Título de la barra de aplicación
      ),
      body: Stack(
        children: [
          HomeView(), // Vista de inicio integrada como un widget
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
                child: FloatingActionButton(
                  onPressed: () => _handleSignOut(
                      context), // Llama al método de cierre de sesión
                  tooltip: 'Cerrar Sesión', // Tooltip del botón
                  child: Icon(Icons.logout), // Icono de cierre de sesión
                  backgroundColor:
                      Colors.grey.withOpacity(0.3), // Color de fondo del botón
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                child: FloatingActionButton(
                  onPressed: () => _showAppInfo(
                      context), // Llama al método para mostrar información de la App
                  tooltip: 'Mostrar información de la App', // Tooltip del botón
                  child: Icon(Icons.info), // Icono de información
                  backgroundColor:
                      Colors.grey.withOpacity(0.3), // Color de fondo del botón
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
