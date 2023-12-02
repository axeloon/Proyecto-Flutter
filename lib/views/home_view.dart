// Importaciones de paquetes y archivos necesarios
import 'package:flutter/material.dart';
import '../pages/rooms_page.dart';
import '../pages/reserve_rooms_page.dart';
import '../pages/history_page.dart';

// Enumeración para representar las opciones disponibles
enum Option { explore, reserve, history }

// Clase que define la vista principal de la aplicación
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Estructura principal de la pantalla
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(
              186, 240, 240, 1), // Configuración del color de fondo
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado de la página de inicio
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(44, 173, 173, 1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Center(
                    child: Text(
                      'Inicio', // Título principal de la página
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        fontFamily: 'Inknut Antiqua',
                        fontSize: 40,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                // Construcción de las tarjetas de opciones
                buildOptionCard(Option.explore, context),
                SizedBox(
                  height: 20,
                ),
                buildOptionCard(Option.reserve, context),
                SizedBox(
                  height: 20,
                ),
                buildOptionCard(Option.history, context),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir las tarjetas de opciones
  Widget buildOptionCard(Option option, BuildContext context) {
    String title;
    switch (option) {
      case Option.explore:
        title = 'Exploración de salas'; // Título para la opción de exploración
        break;
      case Option.reserve:
        title = 'Reserva de salas'; // Título para la opción de reserva
        break;
      case Option.history:
        title =
            'Consulta / Eliminación de salas'; // Título para la opción de historial
        break;
    }

    // Construcción de la tarjeta de opción
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title, // Título de la tarjeta de opción
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Inter',
            fontSize: 24,
            letterSpacing: 0,
            fontWeight: FontWeight.normal,
            height: 1,
          ),
        ),
        onTap: () => navigateToOption(
            option, context), // Navegar a la opción seleccionada
      ),
    );
  }

  // Método para navegar a diferentes páginas según la opción seleccionada
  void navigateToOption(Option option, BuildContext context) {
    switch (option) {
      case Option.explore:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  RoomsPage()), // Navegar a la página de exploración de salas
        );
        break;
      case Option.reserve:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ReserveRoomsPage()), // Navegar a la página de reserva de salas
        );
        break;
      case Option.history:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HistoryPage()), // Navegar a la página de historial de salas
        );
        break;
    }
  }
}
