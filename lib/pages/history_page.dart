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
            decoration: InputDecoration(labelText: 'Room Code'),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _dateController,
            decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Al hacer clic en el botón, realiza la solicitud de historial
              setState(() {
                _fetchHistoryFuture = HistoryService.fetchHistory(
                  _roomCodeController.text,
                  _dateController.text,
                );
              });
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                        ),
                      );
                    },
                  )
                      : const Center(child: Text('No hay historial disponible.'));
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}





