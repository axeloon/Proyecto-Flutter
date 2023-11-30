class LocalTime {
  int hour;
  int minute;
  int second;

  LocalTime({
    required this.hour,
    required this.minute,
    required this.second,
  });

  @override
  String toString() {
    return '$hour:${minute.toString().padLeft(2, '0')}:${second.toString().padLeft(2, '0')}';
  }
}

class Request {
  List<String> roomCode;
  String date;
  LocalTime start;
  int quantity; // Cambié el nombre del campo de studentQuantity a quantity

  Request({
    required this.roomCode,
    required this.date,
    required this.start,
    required this.quantity, // Cambié el nombre del campo de studentQuantity a quantity
  });

  // Método toJson actualizado para reflejar el cambio
  Map<String, dynamic> toJson() {
    return {
      'roomCode': roomCode,
      'date': date,
      'start':
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}:${start.second.toString().padLeft(2, '0')}',
      'quantity': quantity,
    };
  }
}
