import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/pages_routes.dart';
import 'home/ui/provider/home_provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeProvider()),
      //En este Espacio podemos agregar nuevos provider
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tennis',
      routes: Pagasroutes.routes,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: "/",
      theme: ThemeData(
        fontFamily: 'calibri',
        primarySwatch: Colors.blue,
      ),
    );
  }
}
