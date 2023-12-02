class History {
  final String token; // Token asociado a la historia
  final String userEmail; // Correo electrónico del usuario
  final String roomCode; // Código de la sala en la historia
  final String start; // Hora de inicio de la reserva en la historia
  final String end; // Hora de finalización de la reserva en la historia

  // Constructor de la clase History
  History({
    required this.token, // Requiere el token asociado a la historia
    required this.userEmail, // Requiere el correo electrónico del usuario
    required this.roomCode, // Requiere el código de la sala en la historia
    required this.start, // Requiere la hora de inicio de la reserva en la historia
    required this.end, // Requiere la hora de finalización de la reserva en la historia
  });

  // Método factory para construir una instancia de History desde un mapa (JSON)
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      token: json['token'], // Campo: Token asociado a la historia
      userEmail: json['userEmail'], // Campo: Correo electrónico del usuario
      roomCode: json['roomCode'], // Campo: Código de la sala en la historia
      start:
          json['start'], // Campo: Hora de inicio de la reserva en la historia
      end: json[
          'end'], // Campo: Hora de finalización de la reserva en la historia
    );
  }
}
