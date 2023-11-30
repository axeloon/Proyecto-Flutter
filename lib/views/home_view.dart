import 'package:flutter/material.dart';
import '../pages/rooms_page.dart';
import '../pages/reserve_rooms_page.dart'; // Importa la página de reserva de salas

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('Home'),
      ), */
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            // Agregado para el título "INICIO"
            decoration: const BoxDecoration(
              color:
                  Color.fromRGBO(44, 173, 173, 1), // Color de fondo del título
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: const Center(
              child: Text(
                'INICIO',
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
          const SizedBox(
            height: 40,
          ),
          buildOptionCard('Exploración de salas', context),
          const SizedBox(
            height: 20,
          ),
          buildOptionCard('Reserva de salas', context),
          const SizedBox(
            height: 20,
          ),
          buildOptionCard('Historial de reservas', context),
          const SizedBox(
            height: 20,
          ),
          buildOptionCard('Anular reserva', context),
        ],
      ),
    );
  }

  Widget buildOptionCard(String title, BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
          title: Text(
            title,
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
          onTap: () {
            if (title == 'Exploración de salas') {
              // Redirigir a rooms_page.dart
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoomsPage()),
              );
            } else if (title == 'Reserva de salas') {
              // Redirigir a la página de reserva de salas
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReserveRoomsPage()),
              );
            } else {
              // Manejar otras opciones si es necesario
            }
          }),
    );
  }
}
