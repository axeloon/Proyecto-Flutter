import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../models/room.dart';

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late Future<List<Room>> _fetchRoomsFuture;
  int _minCapacity = 0;

  @override
  void initState() {
    super.initState();
    _fetchRoomsFuture = RoomService.fetchRooms();
  }

  List<Room> _filterRoomsByCapacity(List<Room> rooms) {
    return _minCapacity != -1
        ? rooms.where((room) => room.capacity >= _minCapacity).toList()
        : [];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Salas Disponibles'),
    ),
    body: Container(
      color: const Color.fromRGBO(186, 240, 240, 1),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capacidad mínima',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _minCapacity = value.isEmpty
                      ? 0
                      : value.contains(RegExp(r'^[0-9]+$'))
                      ? int.parse(value)
                      : -1;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Room>>(
              future: _fetchRoomsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar las salas. Por favor, inténtelo nuevamente.',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  List<Room> allRooms = snapshot.data ?? [];
                  List<Room> filteredRooms = _filterRoomsByCapacity(allRooms);

                  return filteredRooms.isNotEmpty
                      ? ListView.builder(
                    itemCount: filteredRooms.length,
                    itemBuilder: (context, index) {
                      final room = filteredRooms[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            room.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Ubicación: ${room.location}'),
                              Text('Código: ${room.code}'),
                              Text('Capacidad: ${room.capacity.toString()}'),
                            ],
                          ),
                          onTap: () {
                            // Acciones al tocar una sala (Opcional por el momento)
                          },
                        ),
                      );
                    },
                  )
                      : const Center(child: Text('No hay salas disponibles.'));
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

