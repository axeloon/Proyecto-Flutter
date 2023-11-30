import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/room.dart';
import 'token_storage.dart';

class RoomService {
  static final Uri apiUrl = Uri.https('api.sebastian.cl', 'booking/v1/rooms/');

  static Future<List<Room>> fetchRooms() async {
    final String? token = TokenStorage.idToken;

    if (token == null) {
      throw Exception('El token de sesión es nulo.');
    }

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Room> rooms = jsonResponse.map((room) {
          return Room.fromJson(room);
        }).toList();
        return rooms;
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al realizar la solicitud: $error');
      throw Exception('Error al realizar la solicitud: $error');
    }
  }
}
