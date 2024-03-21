import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/colores.widgets.dart';
import 'CardButton_screen.dart';
import 'newBooking_screen.dart';
import 'provider/home_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Agendamientos'),
          backgroundColor: ColoresGenerales.mainColor,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            // Asegúrate de que el contenido ocupe al menos el tamaño de la pantalla
            padding: const EdgeInsets.all(16.0),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CardButton(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<HomeProvider>().clima = "";
            // Mostrar la página de agregar agendamiento como un modal
            showModalBottomSheet(
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              context: context,
              builder: (BuildContext context) {
                return Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.7, // Establece una altura máxima del 80% de la altura de la pantalla
                  ),
                  child: AddBookingPage(),
                );
              },
            );
          },
          label: const Text('Agendar'),
          icon: const Icon(Icons.add),
          //backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
