import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/room_service.dart';
import '../models/room.dart';
import '../models/request.dart';
import '../services/room_request.dart';

class ReserveRoomsPage extends StatefulWidget {
  @override
  _ReserveRoomsPageState createState() => _ReserveRoomsPageState();
}

class _ReserveRoomsPageState extends State<ReserveRoomsPage> {
  late Future<List<Room>> _fetchRoomsFuture;
  Room? _selectedRoom;
  late List<Room> _rooms = []; // Variable para almacenar las salas

  @override
  void initState() {
    super.initState();
    _fetchRoomsFuture = _fetchRooms();
  }

  Future<List<Room>> _fetchRooms() async {
    try {
      final List<Room> rooms = await RoomService.fetchRooms();
      setState(() {
        _rooms = rooms; // Actualiza la lista de salas con los datos obtenidos
      });
      return rooms;
    } catch (error) {
      throw Exception('Error al obtener las salas: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserva de Salas'),
      ),
      body: Container(
        width: double.infinity,
        height: 800,
        color: Color.fromRGBO(186, 240, 240, 1),
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<Room>>(
          future: _fetchRoomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              if (_rooms.isNotEmpty) {
                return ListView.builder(
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text('Nombre: ${room.name}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Ubicación: ${room.location}'),
                                    Text('Código: ${room.code}'),
                                    Text(
                                        'Capacidad: ${room.capacity.toString()}'),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedRoom = room;
                                  });
                                },
                              ),
                              if (_selectedRoom == room)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _reserveRoom(_selectedRoom!);
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
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return const Center(child: Text('No hay salas disponibles.'));
              }
            }
          },
        ),
      ),
    );
  }

  void _reserveRoom(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _dateController = TextEditingController();
        final _quantityController = TextEditingController();
        final _studentsController = TextEditingController();

        var room_code = room.code;
        return AlertDialog(
          title: Text('Completar solicitud de reserva: Sala $room_code'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha (yyyy-mm-dd)',
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Hora de inicio (17:00:00)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _studentsController,
                  decoration: const InputDecoration(
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
                        _submitReservation(
                          room.code,
                          _dateController.text,
                          _quantityController.text,
                          int.tryParse(_studentsController.text) ?? 0,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text('Reservar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
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

  void _showSuccessDialog(String room, String startTime, String token,
      String date, String userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Reserva exitosa',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sala $room reservada con éxito',
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Hora: $startTime',
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Fecha: $date', // Mostrar la fecha obtenida
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Token: $token', // Mostrar el token obtenido
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Correo electrónico: $userEmail', // Mostrar el correo electrónico obtenido
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: token));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Token copiado al portapapeles')),
                    );
                  },
                  child: Text('Copiar Token'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _submitReservation(
      String room, String date, String quantity, int students) async {
    try {
      Request reservationRequest = Request(
        roomCode: room,
        date: date,
        start: quantity,
        quantity: students,
      );

      var reservationResponse =
          await RoomRequest.reserveRoom(reservationRequest);

      // Verificar si la respuesta contiene datos
      if (reservationResponse.isNotEmpty) {
        // Podrías iterar sobre los elementos de la lista
        for (var responseData in reservationResponse) {
          // Tratar cada elemento según sea necesario
          // Ejemplo de acceso a los datos (dependiendo de la estructura de la lista)
          String token = responseData['token'];
          String userEmail = responseData['userEmail'];
          String startTime = responseData['start'];

          _showSuccessDialog(room, startTime, token, date, userEmail);
          print('Sala $room reservada con éxito');
        }
      } else {
        throw Exception('Respuesta de reserva vacía');
      }
    } catch (error) {
      print('Error al reservar la sala: $error');
      // Manejar el error, mostrar un diálogo de error, etc.
    }
  }
}
