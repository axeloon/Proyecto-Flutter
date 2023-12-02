// Importación de paquetes y archivos necesarios
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/room_service.dart';
import '../models/room.dart';
import '../models/request.dart';
import '../services/room_request.dart';

// Clase StatefulWidget para la página de reserva de salas
class ReserveRoomsPage extends StatefulWidget {
  @override
  _ReserveRoomsPageState createState() => _ReserveRoomsPageState();
}

// Estado asociado a la página de reserva de salas
class _ReserveRoomsPageState extends State<ReserveRoomsPage> {
  late Future<List<Room>>
      _fetchRoomsFuture; // Futuro para obtener la lista de salas
  Room? _selectedRoom; // Sala seleccionada actualmente
  late List<Room> _rooms = []; // Variable para almacenar las salas disponibles

  @override
  void initState() {
    super.initState();
    _fetchRoomsFuture = _fetchRooms(); // Obtener las salas al iniciar la página
  }

  // Método para obtener la lista de salas desde el servicio
  Future<List<Room>> _fetchRooms() async {
    try {
      final List<Room> rooms =
          await RoomService.fetchRooms(); // Obtener las salas del servicio
      setState(() {
        _rooms = rooms; // Actualizar la lista de salas con los datos obtenidos
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
        title:
            const Text('Reserva de Salas'), // Título de la barra de aplicación
      ),
      body: Container(
        width: double.infinity,
        height: 800,
        color: Color.fromRGBO(186, 240, 240, 1), // Color de fondo
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<Room>>(
          future: _fetchRoomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                      CircularProgressIndicator()); // Mostrar indicador de carga mientras se obtienen las salas
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                      'Error: ${snapshot.error}')); // Mostrar mensaje de error si ocurre un problema
            } else {
              if (_rooms.isNotEmpty) {
                return ListView.builder(
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tarjeta para cada sala disponible
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                    'Nombre: ${room.name}'), // Mostrar nombre de la sala
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Ubicación: ${room.location}'), // Mostrar ubicación de la sala
                                    Text(
                                        'Código: ${room.code}'), // Mostrar código de la sala
                                    Text(
                                        'Capacidad: ${room.capacity.toString()}'), // Mostrar capacidad de la sala
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    _selectedRoom =
                                        room; // Al seleccionar una sala, asignarla como sala seleccionada
                                  });
                                },
                              ),
                              // Mostrar botones de reserva si la sala está seleccionada
                              if (_selectedRoom == room)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _reserveRoom(
                                              _selectedRoom!); // Método para reservar la sala seleccionada
                                        },
                                        child: Text('Reservar'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _selectedRoom =
                                                null; // Cancelar la selección de la sala
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
                return const Center(
                    child: Text(
                        'No hay salas disponibles.')); // Mostrar mensaje si no hay salas disponibles
              }
            }
          },
        ),
      ),
    );
  }

  // Método para mostrar un diálogo de solicitud de reserva
  void _reserveRoom(Room room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _dateController = TextEditingController();
        final _quantityController = TextEditingController();
        final _studentsController = TextEditingController();

        var room_code = room.code; // Código de la sala seleccionada
        return AlertDialog(
          title: Text(
              'Completar solicitud de reserva: Sala $room_code'), // Título del diálogo con el nombre de la sala
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText:
                        'Fecha (yyyy-mm-dd)', // Campo para ingresar la fecha de reserva
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText:
                        'Hora de inicio (17:00:00)', // Campo para ingresar la hora de inicio
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                TextFormField(
                  controller: _studentsController,
                  decoration: const InputDecoration(
                    labelText:
                        'Cantidad de alumnos (1)', // Campo para ingresar la cantidad de alumnos
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _submitReservation(
                          // Método para enviar la solicitud de reserva
                          room.code,
                          _dateController.text,
                          _quantityController.text,
                          int.tryParse(_studentsController.text) ?? 0,
                        );
                        Navigator.of(context).pop(); // Cerrar el diálogo
                      },
                      child: Text('Reservar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Cancelar la reserva y cerrar el diálogo
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

  // Método para mostrar un diálogo de éxito de reserva
  void _showSuccessDialog(String room, String startTime, String token,
      String date, String userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green), // Icono de éxito
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
                    Clipboard.setData(ClipboardData(
                        text: token)); // Copiar el token al portapapeles
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

  // Método para enviar la solicitud de reserva al servidor
  void _submitReservation(
      String room, String date, String quantity, int students) async {
    try {
      Request reservationRequest = Request(
        roomCode: room,
        date: date,
        start: quantity,
        quantity: students,
      );

      var reservationResponse = await RoomRequest.reserveRoom(
          reservationRequest); // Enviar solicitud de reserva al servicio

      if (reservationResponse.isNotEmpty) {
        for (var responseData in reservationResponse) {
          String token = responseData['token']; // Obtener el token de reserva
          String userEmail = responseData[
              'userEmail']; // Obtener el correo electrónico asociado
          String startTime = responseData['start']; // Obtener la hora de inicio

          _showSuccessDialog(room, startTime, token, date,
              userEmail); // Mostrar diálogo de éxito
          print('Sala $room reservada con éxito');
        }
      } else {
        throw Exception('Respuesta de reserva vacía');
      }
    } catch (error) {
      print(
          'Error al reservar la sala: $error'); // Manejar error al reservar sala
    }
  }
}
