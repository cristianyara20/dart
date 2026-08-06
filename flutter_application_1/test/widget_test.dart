import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/app/app.dart';

void main() {
  testWidgets('Renders Hello World text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that MiText widget is present with "Hello World".
    expect(find.text('Hello World'), findsOneWidget);
  });
}
