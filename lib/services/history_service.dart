import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/history.dart';
import 'token_storage.dart';

class HistoryService {
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
}



