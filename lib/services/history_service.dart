import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/history.dart';
import 'token_storage.dart';

class HistoryService {
  // Método para obtener el historial
  static Future<List<History>> fetchHistory(String roomCode, String isoDate) async {
    final Uri historyUrl = Uri.https(
      'api.sebastian.cl',
      'booking/v1/reserve/$roomCode/schedule/$isoDate',
    );

    final String? token = TokenStorage.idToken;

    if (token == null) {
      throw Exception('El token de sesión es nulo.');
    }

    try {
      final response = await http.get(
        historyUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<History> historyList =
        responseData.map((data) => History.fromJson(data)).toList();
        return historyList;
      } else {
        throw Exception(
            'Error al obtener el historial. Código de estado: ${response.statusCode}. Mensaje: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error al realizar la solicitud para obtener el historial: $error');
    }
  }

  // Método para eliminar una reserva y devolver el código de estado
  static Future<int> deleteReservation(String token) async {
    final Uri deleteUrl = Uri.https('api.sebastian.cl', 'booking/v1/reserve/$token/cancel');

    final String? authToken = TokenStorage.idToken;

    if (authToken == null) {
      throw Exception('El token de sesión es nulo.');
    }

    try {
      final response = await http.delete(
        deleteUrl,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode; // Devuelve el código de estado
    } catch (error) {
      throw Exception('Error al realizar la solicitud para eliminar la reserva: $error');
    }
  }
}



