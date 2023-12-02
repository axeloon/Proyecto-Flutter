import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/request.dart'; // Importa el modelo de solicitud
import 'token_storage.dart'; // Importa el almacenamiento del token

// Clase que maneja las solicitudes relacionadas con las salas
class RoomRequest {
  // URL para la reserva de salas
  static final Uri reserveUrl =
      Uri.https('api.sebastian.cl', 'booking/v1/reserve/request');

  // Método estático para reservar una sala
  static Future<List<dynamic>> reserveRoom(Request request) async {
    final String? token =
        TokenStorage.idToken; // Obtiene el token de almacenamiento

    // Comprueba si el token es nulo y maneja el error si lo es
    if (token == null) {
      throw Exception('El token de sesión es nulo.');
    }

    try {
      final response = await http.post(
        reserveUrl, // URL de la reserva de salas
        headers: {
          'Authorization':
              'Bearer $token', // Encabezado de autorización con el token
          'Content-Type': 'application/json', // Tipo de contenido JSON
        },
        body: jsonEncode(
            request.toJson()), // Cuerpo de la solicitud codificado en JSON
      );

      if (response.statusCode == 201) {
        // Si el estado de la respuesta es 201 (creado)
        // Parsear la respuesta JSON como una lista de datos dinámicos
        final List<dynamic> responseData = jsonDecode(response.body);
        // Retornar la lista de datos
        return responseData;
      } else {
        // Manejo de errores si no se obtiene un estado de respuesta exitoso
        throw Exception(
            'Error al reservar la sala. Código de estado: ${response.statusCode}. Mensaje: ${response.body}');
      }
    } catch (error) {
      // Manejo de errores en caso de problemas durante la solicitud
      throw Exception('Error al realizar la solicitud de reserva: $error');
    }
  }
}
