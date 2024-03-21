import 'package:flutter/cupertino.dart';
import '../home/ui/home_screen.dart';
import '../home/ui/newBooking_screen.dart';
import 'routes.dart';

abstract class Pagasroutes {
  static Map<String, Widget Function(BuildContext)> routes = {
    Routes.home: (BuildContext context) => HomeScreen(),
    Routes.addBookingPage: (BuildContext context) => AddBookingPage(),
  };
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(
            builder: (BuildContext context) => HomeScreen());
      case '/AddBookingPage':
        return CupertinoPageRoute(
            builder: (BuildContext context) => AddBookingPage());
      default:
        return CupertinoPageRoute(
            builder: (BuildContext context) => HomeScreen());
    }
  }
}
