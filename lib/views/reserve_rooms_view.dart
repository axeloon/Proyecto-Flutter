import 'package:flutter/material.dart';

// Clase StatelessWidget para la vista de reserva de salas
class ReserveRoomsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ancho del contenedor igual al ancho disponible
      height: 800, // Altura fija del contenedor
      color: Color.fromRGBO(186, 240, 240, 1), // Color de fondo del contenedor
      padding: EdgeInsets.all(20), // Relleno interior del contenedor
      child:
          SizedBox(), // Espacio vacío como hijo del contenedor para mostrar solo el fondo
    );
  }
}
