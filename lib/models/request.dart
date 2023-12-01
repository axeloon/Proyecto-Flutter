class Request {
  String roomCode;
  String date;
  String start; // Cambiar el campo start a String
  int quantity;

  Request({
    required this.roomCode,
    required this.date,
    required this.start,
    required this.quantity,
  });

  // Método toJson actualizado para reflejar el cambio
  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'date': date,
      'start': start, // Usar directamente el campo start como String
      'quantity': quantity,
    };
  }
}
