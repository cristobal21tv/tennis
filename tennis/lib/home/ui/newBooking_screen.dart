import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/colores.widgets.dart';
import '../data/models/Booking.dart';
import 'provider/home_provider.dart';

class AddBookingPage extends StatefulWidget {
  @override
  _AddBookingPageState createState() => _AddBookingPageState();
}

class _AddBookingPageState extends State<AddBookingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  DateTime? selectedDate;
  String selectedCacha = "A";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      // Si el usuario selecciona una fecha, actualiza el estado del widger
      var date = '${picked.day}/${picked.month}/${picked.year}';
      await Provider.of<HomeProvider>(context, listen: false)
          .obtenerPronostico(date);
      _dateController.text = date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> canchas = ['A', 'B', 'C'];
    return Consumer<HomeProvider>(builder: (context, homeProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Agregar Agendamiento'),
          backgroundColor: ColoresGenerales.mainColor,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Selecciona una cancha',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedCacha,
                        items: canchas.map((cancha) {
                          return DropdownMenuItem<String>(
                            value: cancha,
                            child: Text(cancha),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCacha = "$value";
                          });
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Selecciona una fecha',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly:
                            true, // Hace que el campo de texto sea de solo lectura
                        onTap: () {
                          _selectDate(context);
                        },
                        onChanged: (value) {
                          print('value');
                          //homeProvider.obtenerPronostico(_dateController.text);
                        },
                        controller: _dateController,
                      ),
                      Row(
                        children: [
                          Text(
                            'probabilidad de lluvia: ${homeProvider.clima}',
                            style: const TextStyle(
                              //color: ColoresGenerales.azulColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.shower,
                              color: ColoresGenerales.secondaryColor),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                            labelText: 'Nombre de Usuario'),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Obtener los valores del formulario
                            String court = selectedCacha;
                            String date = _dateController.text;
                            String userName = _userNameController.text;
                            String? clima = homeProvider.clima;

                            // Crear un nuevo objeto Booking con los valores del formulario
                            Booking newBooking = Booking(
                              court: court,
                              date: date,
                              userName: userName,
                              clima: clima,
                            );

                            // Llamar al método para agregar el agendamiento desde el provider

                            final success = await Provider.of<HomeProvider>(
                                    context,
                                    listen: false)
                                .addBooking(newBooking);
                            if (success) {
                              // Limpiar los campos del formulario después de agregar el agendamiento
                              _dateController.clear();
                              _userNameController.clear();

                              // Mostrar un mensaje de confirmación
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Agendamiento agregado')));
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: const Text('Agregar Agendamiento'),
                      ),
                      Text(
                        homeProvider.messageError,
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
