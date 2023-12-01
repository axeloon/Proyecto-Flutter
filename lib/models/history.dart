class History {
  final String token;
  final String userEmail;
  final String roomCode;
  final String start;
  final String end;

  History({
    required this.token,
    required this.userEmail,
    required this.roomCode,
    required this.start,
    required this.end,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      token: json['token'],
      userEmail: json['userEmail'],
      roomCode: json['roomCode'],
      start: json['start'],
      end: json['end'],
    );
  }
}