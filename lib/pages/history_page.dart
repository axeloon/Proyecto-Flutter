import 'package:flutter/material.dart';
import '../services/history_service.dart';
import '../models/history.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TextEditingController _roomCodeController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  late Future<List<History>> _fetchHistoryFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa la lista de historial con valores vacíos
    _fetchHistoryFuture = Future.value([]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Historial de Reservas'),
        ),
        body: Container(
          color: const Color.fromRGBO(186, 240, 240, 1),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _roomCodeController,
                decoration: InputDecoration(labelText: 'Codigo Sala'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Fecha(AAAA-MM-DD)'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Realiza la solicitud de busqueda de la reserva
                  _fetchHistory();
                },
                child: const Text('Buscar Historial'),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: FutureBuilder<List<History>>(
                  future: _fetchHistoryFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error al cargar el historial. Por favor, inténtelo nuevamente.',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      List<History> historyList = snapshot.data ?? [];

                      return historyList.isNotEmpty
                          ? ListView.builder(
                              itemCount: historyList.length,
                              itemBuilder: (context, index) {
                                final history = historyList[index];
                                return Card(
                                  margin: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      'Token: ${history.token}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Usuario: ${history.userEmail}'),
                                        Text('Sala: ${history.roomCode}'),
                                        Text('Inicio: ${history.start}'),
                                        Text('Fin: ${history.end}'),
                                      ],
                                    ),
                                    onTap: () {
                                      // Acciones al tocar un elemento del historial
                                    },
                                    // Añade un botón de "Eliminar" en cada elemento de la lista
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // Lógica para eliminar la reserva
                                        _showDeleteConfirmationDialog(
                                            history.token);
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text('No hay historial disponible.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );

  // Método para mostrar un diálogo de confirmación antes de eliminar la reserva
  void _showDeleteConfirmationDialog(String token) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Reserva'),
          content: Text('¿Estás seguro de que deseas eliminar esta reserva?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Lógica para eliminar la reserva (llamar al servicio correspondiente)
                _deleteReservation(token);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  // Método para eliminar la reserva usando el servicio correspondiente
  void _deleteReservation(String token) {
    // Llamar al servicio para eliminar la reserva con el token proporcionado
    HistoryService.deleteReservation(token).then((statusCode) {
      // Verificar el código de estado devuelto por el servicio
      if (statusCode == 204) {
        // Éxito al eliminar la reserva
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Reserva eliminada exitosamente.'),
          duration: Duration(seconds: 2),
        ));

        // Recargar el historial después de la eliminación
        _fetchHistory();
      } else {
        // Manejar otros códigos de estado si es necesario
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Error al eliminar la reserva. Código de estado: $statusCode.'),
          duration: Duration(seconds: 2),
        ));
      }
    }).catchError((error) {
      // Manejar errores si es necesario
      print('Error al eliminar la reserva: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Error al eliminar la reserva. Por favor, inténtelo nuevamente.'),
        duration: Duration(seconds: 2),
      ));
    });
  }

  // Método para realizar una nueva solicitud de historial
  void _fetchHistory() {
    setState(() {
      _fetchHistoryFuture = HistoryService.fetchHistory(
        _roomCodeController.text,
        _dateController.text,
      );
    });
  }
}
