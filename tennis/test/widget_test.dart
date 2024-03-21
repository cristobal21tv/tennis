import 'package:flutter_test/flutter_test.dart';

import 'package:tennis/main.dart';

void main() {
  testWidgets('Prueba de creacion de la reserva', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
  });
}
