class Request {
  String roomCode; // Código de la sala
  String date; // Fecha de la solicitud
  String start; // Hora de inicio como String
  int quantity; // Cantidad

  // Constructor de la clase Request
  Request({
    required this.roomCode, // Requiere el código de la sala
    required this.date, // Requiere la fecha de la solicitud
    required this.start, // Requiere la hora de inicio como String
    required this.quantity, // Requiere la cantidad
  });

  // Método toJson para convertir los datos a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode, // Campo: Código de la sala
      'date': date, // Campo: Fecha de la solicitud
      'start': start, // Campo: Hora de inicio como String
      'quantity': quantity, // Campo: Cantidad
    };
  }
}
