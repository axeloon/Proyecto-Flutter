import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTEM Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

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

class TokenStorage {
  static String? _idToken;

  static String? get idToken => _idToken;

  static void setToken(String? token) {
    _idToken = token;
  }
}

class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  //final String apiUrl = 'https://api.sebastian.cl/booking/v1/rooms/';

  final apiUrl = Uri.https('api.sebastian.cl', 'booking/v1/rooms/');

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final String? idToken = googleAuth.idToken;
        TokenStorage.setToken(idToken); // Almacena el token

        if (idToken != null) {
          // Mostrar la lista de salas en la pantalla Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          print('El token de sesión es nulo.');
          // Aquí puedes manejar el caso cuando el token de sesión es nulo
        }
      } else {
        print('Inicio de sesión cancelado.');
      }
    } catch (error) {
      print('Error al iniciar sesión: $error');
    }
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      await _googleSignIn.signOut();

      print('Cierre de sesión exitoso');

      // Una vez cerrada la sesión, puedes redirigir al usuario a la pantalla de inicio o a donde sea necesario
      // Por ejemplo:
      //Navigator.pushReplacementNamed(context, '/login'); // Reemplaza '/login' con la ruta de tu pantalla de inicio de sesión
    } catch (error) {
      print('Error al cerrar sesión: $error');
      // Aquí puedes manejar cualquier error que surja al cerrar sesión
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UTEM Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _handleSignIn(context),
              child: Text('Iniciar Sesión con Google'),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            ElevatedButton(
              onPressed: () => _handleSignOut(context),
              child: Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

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
        title: Text('Salas Disponibles'),
      ),
      body: FutureBuilder<List<Room>>(
        future: _fetchRoomsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Room>? rooms = snapshot.data;
            if (rooms != null && rooms.isNotEmpty) {
              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
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
              return Center(child: Text('No hay salas disponibles.'));
            }
          }
        },
      ),
    );
  }
}

class RoomService {
  static final Uri apiUrl = Uri.https('api.sebastian.cl', 'booking/v1/rooms/');

  static Future<List<Room>> fetchRooms() async {
    final String? token = TokenStorage.idToken; // Obtiene el token almacenado

    if (token == null) {
      throw Exception('El token de sesión es nulo.');
    }

    try {
      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        List<Room> rooms = jsonResponse.map((room) {
          return Room.fromJson(room);
        }).toList();
        return rooms;
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (error) {
      throw Exception('Error al realizar la solicitud: $error');
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomsPage(),
              ),
            );
          },
          child: Text('Ver Salas'),
        ),
      ),
    );
  }
}
