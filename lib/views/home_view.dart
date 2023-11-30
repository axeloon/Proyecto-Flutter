import 'package:flutter/material.dart';
import '../pages/rooms_page.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('Home'),
      ), */
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(186, 240, 240, 1),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
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
              SizedBox(
                height: 40,
              ),
              buildOptionCard('Exploración de salas', context),
              SizedBox(
                height: 20,
              ),
              buildOptionCard('Reserva de salas', context),
              SizedBox(
                height: 20,
              ),
              buildOptionCard('Anular reserva', context),
              SizedBox(
                height: 20,
              ),
              buildOptionCard('Historial de reservas', context),
            ],
          ),
        ),
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
          style: TextStyle(
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
          } else {
            // Manejar otras opciones si es necesario
          }
        },
      ),
    );
  }
}

Widget buildOptionCard(String title, BuildContext context) {
  return Card(
    elevation: 4,
    child: ListTile(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
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
        } else {
          // Manejar otras opciones si es necesario
        }
      },
    ),
  );
}
