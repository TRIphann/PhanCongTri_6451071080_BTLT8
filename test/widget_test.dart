import 'package:flutter_test/flutter_test.dart';
import 'package:bai8/main.dart';

void main() {
  testWidgets('App should show exercise menu', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('Bài 1'), findsOneWidget);
    expect(find.text('Bài 2'), findsOneWidget);
  });
}
