import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/room.dart'; // Importa el modelo de sala
import 'token_storage.dart'; // Importa el almacenamiento del token

class RoomService {
  static final Uri apiUrl = Uri.https('api.sebastian.cl',
      'booking/v1/rooms/'); // URL de la API para obtener las salas

  // Función para obtener las salas disponibles
  static Future<List<Room>> fetchRooms() async {
    final String? token =
        TokenStorage.idToken; // Obtiene el token de almacenamiento

    if (token == null) {
      throw Exception(
          'El token de sesión es nulo.'); // Lanza una excepción si el token es nulo
    }

    try {
      final response = await http.get(
        apiUrl, // Realiza una solicitud GET a la URL de la API
        headers: {
          'Authorization':
              'Bearer $token', // Establece el token en los encabezados de la solicitud
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            jsonDecode(response.body); // Decodifica la respuesta JSON
        List<Room> rooms = jsonResponse.map((room) {
          return Room.fromJson(
              room); // Mapea los datos JSON a objetos de la clase Room
        }).toList();
        return rooms; // Retorna la lista de salas
      } else {
        throw Exception(
            'Failed to load rooms: ${response.statusCode}'); // Lanza una excepción si la solicitud falla
      }
    } catch (error) {
      print(
          'Error al realizar la solicitud: $error'); // Imprime el error en la consola
      throw Exception(
          'Error al realizar la solicitud: $error'); // Lanza una excepción en caso de error
    }
  }
}
