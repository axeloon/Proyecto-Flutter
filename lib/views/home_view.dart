import 'package:flutter/material.dart';
import '../pages/rooms_page.dart';
import '../pages/reserve_rooms_page.dart';
import '../pages/history_page.dart';
enum Option { explore, reserve, history, cancel } // Enum para las opciones

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(186, 240, 240, 1),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                SizedBox(
                  height: 40,
                ),
                buildOptionCard(Option.explore, context), // Corregido
                SizedBox(
                  height: 20,
                ),
                buildOptionCard(Option.reserve, context), // Corregido
                SizedBox(
                  height: 20,
                ),
                buildOptionCard(Option.history, context), // Corregido
                SizedBox(
                  height: 20,
                ),
                buildOptionCard(Option.cancel, context), // Corregido
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionCard(Option option, BuildContext context) {
    String title;
    switch (option) {
      case Option.explore:
        title = 'Exploración de salas';
        break;
      case Option.reserve:
        title = 'Reserva de salas';
        break;
      case Option.history:
        title = 'Historial de reservas';
        break;
      case Option.cancel:
        title = 'Anular reserva';
        break;
    }

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
        onTap: () => navigateToOption(option, context),
      ),
    );
  }

  void navigateToOption(Option option, BuildContext context) {
    switch (option) {
      case Option.explore:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoomsPage()),
        );
        break;
      case Option.reserve:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReserveRoomsPage()),
        );
        break;
      case Option.history:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HistoryPage()),
        );
        break;
      case Option.cancel:

        break;
    }
  }
}
