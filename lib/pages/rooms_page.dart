import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../models/room.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late Future<List<Room>> _fetchRoomsFuture;

  @override
  void initState() {
    super.initState();
    _fetchRoomsFuture = _fetchRooms();
  }

  Future<List<Room>> _fetchRooms() async {
    try {
      final List<Room> rooms = await RoomService.fetchRooms();
      return rooms;
    } catch (error) {
      throw Exception('Error al obtener las salas: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas Disponibles'),
      ),
      body: FutureBuilder<List<Room>>(
        future: _fetchRoomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Room>? rooms = snapshot.data;
            if (rooms != null && rooms.isNotEmpty) {
              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('Código: ${rooms[index].code}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ubicación: ${rooms[index].location}'),
                          Text('Nombre: ${rooms[index].name}'),
                          Text(
                              'Capacidad: ${rooms[index].capacity.toString()}'),
                        ],
                      ),
                      onTap: () {
                        // Acciones al tocar una sala
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No hay salas disponibles.'));
            }
          }
        },
      ),
    );
  }
}
