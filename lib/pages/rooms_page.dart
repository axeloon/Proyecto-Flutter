import 'package:flutter/material.dart';
import '../services/room_service.dart'; // Importa el servicio de salas
import '../models/room.dart'; // Importa el modelo de sala

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  late Future<List<Room>> _fetchRoomsFuture; // Futuro para obtener las salas
  int _minCapacity = 0; // Capacidad mínima de las salas a mostrar

  @override
  void initState() {
    super.initState();
    _fetchRoomsFuture =
        RoomService.fetchRooms(); // Obtiene las salas al inicializar la página
  }

  // Función para filtrar las salas según la capacidad mínima seleccionada
  List<Room> _filterRoomsByCapacity(List<Room> rooms) {
    return _minCapacity != -1
        ? rooms.where((room) => room.capacity >= _minCapacity).toList()
        : [];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Salas Disponibles'), // Título de la página
        ),
        body: Container(
          color: const Color.fromRGBO(
              186, 240, 240, 1), // Color de fondo del contenedor
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        'Capacidad mínima', // Etiqueta para el campo de entrada
                    suffixIcon: Icon(Icons.search), // Ícono para la búsqueda
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
                  future: _fetchRoomsFuture, // Futuro de las salas
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error al cargar las salas. Por favor, inténtelo nuevamente.',
                          style: TextStyle(
                              color: Colors.red), // Estilo para mostrar errores
                        ),
                      );
                    } else {
                      List<Room> allRooms = snapshot.data ??
                          []; // Lista de todas las salas obtenidas
                      List<Room> filteredRooms = _filterRoomsByCapacity(
                          allRooms); // Salas filtradas por capacidad

                      return filteredRooms.isNotEmpty
                          ? ListView.builder(
                              itemCount: filteredRooms.length,
                              itemBuilder: (context, index) {
                                final room = filteredRooms[index];
                                return Card(
                                  margin: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      room.name, // Nombre de la sala
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Ubicación: ${room.location}'), // Ubicación de la sala
                                        Text(
                                            'Código: ${room.code}'), // Código de la sala
                                        Text(
                                            'Capacidad: ${room.capacity.toString()}'), // Capacidad de la sala
                                      ],
                                    ),
                                    onTap: () {
                                      // Acciones al tocar una sala (Opcional por el momento)
                                    },
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                  'No hay salas disponibles.')); // Mensaje si no hay salas disponibles
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
