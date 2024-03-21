import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/Booking.dart';
import 'provider/home_provider.dart';

class CardButton extends StatefulWidget {
  const CardButton({Key? key}) : super(key: key);

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, listAgendas, child) {
        // Carga los agendamientos desde el provider
        listAgendas.loadBookings();
        List<Booking> bookings = listAgendas.bookings;
        // Ordena los agendamientos por fecha
        bookings.sort((a, b) => a.date.compareTo(b.date));

        return ListView.builder(
          shrinkWrap: true, // Ajusta el tamaño del ListView al contenido
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            Booking booking = bookings[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () async {
                  // Dejo este espacio por si hay que hacer un detalle del agendamiento
                },
                child: Card(
                  margin: EdgeInsets.zero,
                  elevation: 4.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Cancha: ${booking.court}',
                          style: const TextStyle(
                            //color: ColoresGenerales.azulColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.supervised_user_circle,
                                  color: Colors.blue,
                                ),
                                Flexible(
                                  child: Text(
                                    'Usuario: ${booking.userName}',
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.shower,
                                  color: Colors.blue,
                                ),
                                Text(
                                  'probabilidad de lluvia: ${booking.clima}',
                                  style: const TextStyle(
                                    //color: ColoresGenerales.azulColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            //------Horarios------//
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.history, color: Colors.blue),
                                Text(
                                  'Fecha: ${booking.date}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Lógica para eliminar el agendamiento
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: const Text(
                                        '¿Estás seguro de que deseas eliminar este agendamiento?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Cerrar el diálogo
                                        },
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Llama al método para eliminar el agendamiento desde el provider
                                          listAgendas
                                              .deleteBooking(booking.id!);
                                          Navigator.of(context)
                                              .pop(); // Cerrar el diálogo
                                        },
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
