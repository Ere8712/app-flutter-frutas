import 'package:flutter_test/flutter_test.dart';
import 'package:app_flutter_frutas/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FruitMixerApp());
  });
}
