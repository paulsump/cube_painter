
import 'package:cube_painter/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Run app', (WidgetTester tester) async {
    await tester.pumpWidget(createApp());

  });
}
