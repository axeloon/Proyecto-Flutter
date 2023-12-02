import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/request.dart';
import 'token_storage.dart';

class RoomRequest {
  static final Uri reserveUrl = Uri.https('api.sebastian.cl', 'booking/v1/reserve/request');

  static Future<List<dynamic>> reserveRoom(Request request) async {
    final String? token = TokenStorage.idToken;

    if (token == null) {
      throw Exception('El token de sesión es nulo.');
    }

    try {
      final response = await http.post(
        reserveUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        // Parsear la respuesta JSON como una lista
        final List<dynamic> responseData = jsonDecode(response.body);
        // Retornar la lista de datos
        return responseData;
      } else {
        throw Exception(
            'Error al reservar la sala. Código de estado: ${response.statusCode}. Mensaje: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error al realizar la solicitud de reserva: $error');
    }
  }
}
