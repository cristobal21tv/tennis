import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../data/database_connection.dart';
import '../../../services/service_api.dart';
import '../../data/models/Booking.dart';

class HomeProvider with ChangeNotifier, DiagnosticableTreeMixin {
  List<Booking> _bookings = []; // Lista para almacenar los agendamientos
  String _clima = ""; // Lista para almacenar los agendamientos
  final ServiceApi _apiService = ServiceApi();
  List<Booking> get bookings =>
      _bookings; // Getter para obtener los agendamientos

  String get clima => _clima;
  set clima(value) {
    _clima = value;
    notifyListeners();
  }

  String _messageError = "";
  String get messageError => _messageError;

  // Método para cargar los agendamientos desde la base de datos
  Future<void> loadBookings() async {
    final db = await DatabaseConnection.instance.database;
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> queryResult = await db.rawQuery('''
    SELECT * FROM bookings 
    ORDER BY ABS(STRFTIME('%s', date) - STRFTIME('%s', '${now.year}-${now.month}-${now.day}'))
  ''');
    _bookings = queryResult.map((e) => Booking.fromMap(e)).toList();
    notifyListeners();
  }

  // Método para insertar un nuevo agendamiento en la base de datos
  Future<bool> addBooking(Booking booking) async {
    final db = await DatabaseConnection.instance.database;

    final cantidadAgendamientos = await obtenerCantidadAgendamientos(booking);
    // Si hay menos de tres agendamientos, permitir la inserción
    if (cantidadAgendamientos < 3) {
      await db.insert('bookings', booking.toMap());
      await loadBookings();
      _messageError = "";
      return true;
    } else {
      _messageError =
          'No hay disponibilidad para registrar más agendamientos para la fecha y cancha seleccionadas.';
      await loadBookings();
      return false;
    }
  }

  Future<int> obtenerCantidadAgendamientos(Booking booking) async {
    final db = await DatabaseConnection.instance.database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT COUNT(*) AS count FROM Bookings 
    WHERE Court = ? AND Date = ?
  ''', [booking.court, booking.date]);

    if (result.isNotEmpty) {
      return result.first['count'] as int;
    } else {
      return 0; // Si no hay resultados, retornar 0
    }
  }

  // Método para eliminar un agendamiento de la base de datos
  Future<void> deleteBooking(int id) async {
    final db = await DatabaseConnection.instance.database;
    await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
    await loadBookings(); // Recarga los agendamientos después de la eliminación
  }

  Future<void> obtenerPronostico(date) async {
    try {
      // Convertir la fecha original a DateTime
      DateTime dateConvert =
          DateTime.parse(DateFormat("dd/MM/yyyy").parse(date).toString());
      // Formatear la fecha en el formato deseado
      String formattedDate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(dateConvert);
      // Llama al método de tu servicio de API para obtener datos
      var dataClima = await _apiService.obtenerPronostico(formattedDate);
      _clima = dataClima.toString();
      notifyListeners(); // Notifica a los widgets que escuchan los cambios en este proveedor
    } catch (e) {
      // Maneja cualquier error que pueda ocurrir al obtener datos desde la API
      print('Error al obtener datos desde la API: $e');
    }
  }
}
