import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../models/room.dart';
import '../models/request.dart'; // Importa el modelo de solicitud
import '../services/room_request.dart'; // Importa el archivo room_request.dart

class ReserveRoomsPage extends StatefulWidget {
  @override
  _ReserveRoomsPageState createState() => _ReserveRoomsPageState();
}

class _ReserveRoomsPageState extends State<ReserveRoomsPage> {
  late Future<List<Room>> _fetchRoomsFuture;
  Room? _selectedRoom;
  late List<Room> _rooms; // Variable para almacenar las salas

  @override
  void initState() {
    super.initState();
    _fetchRoomsFuture = _fetchRooms();
  }

  Future<List<Room>> _fetchRooms() async {
    try {
      final List<Room> rooms = await RoomService.fetchRooms();
      _rooms = rooms; // Almacena las salas en la variable _rooms
      return rooms;
    } catch (error) {
      throw Exception('Error al obtener las salas: $error');
    }
  }

  void _reserveRoom(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _dateController = TextEditingController();
        final _quantityController = TextEditingController();
        final _studentsController = TextEditingController();

        return AlertDialog(
          title: Text('Completar solicitud de reserva'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Fecha (yyyy-mm-dd)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Hora de inicio (17:00:00)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _studentsController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad de alumnos (1)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _submitReservation(
                          room,
                          _dateController.text,
                          int.tryParse(_quantityController.text) ?? 0,
                          int.tryParse(_studentsController.text) ?? 0,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text('Reservar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitReservation(
      Room room, String date, int quantity, int students) async {
    try {
      DateTime now = DateTime.now();
      LocalTime startTime = LocalTime(
        hour: now.hour,
        minute: now.minute,
        second: now.second,
      );

      Request reservationRequest = Request(
        roomCode: [room.code],
        date: date,
        start: startTime,
        quantity:
            quantity, // Cambié el nombre del campo de studentQuantity a quantity
      );
      print(room);
      print(date);
      print(quantity);
      print(students);

      /* ARREGLAR
I/flutter (12499): Instance of 'Room'
I/flutter (12499): 2023-12-01
I/flutter (12499): 0
I/flutter (12499): 1 */

      await RoomRequest.reserveRoom(reservationRequest);
      print('Sala ${room.code} reservada con éxito');
    } catch (error) {
      print('Error al reservar la sala: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Salas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<List<Room>>(
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
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text('Código: ${rooms[index].code}'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Ubicación: ${rooms[index].location}'),
                                        Text('Nombre: ${rooms[index].name}'),
                                        Text(
                                            'Capacidad: ${rooms[index].capacity.toString()}'),
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _selectedRoom = rooms[index];
                                      });
                                    },
                                  ),
                                  if (_selectedRoom == rooms[index])
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _reserveRoom(_rooms[
                                                index]); // Usar _rooms en lugar de rooms
                                          },
                                          child: Text('Reservar'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedRoom = null;
                                            });
                                          },
                                          child: Text('Cancelar'),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No hay salas disponibles.'));
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
