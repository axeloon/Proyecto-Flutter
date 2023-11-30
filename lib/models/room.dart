class Room {
  final String code;
  final String location;
  final String name;
  final int capacity;

  Room({
    required this.code,
    required this.location,
    required this.name,
    required this.capacity,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      code: json['code'],
      location: json['location'],
      name: json['name'],
      capacity: json['capacity'],
    );
  }
}
