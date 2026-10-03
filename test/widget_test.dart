import 'package:flutter_test/flutter_test.dart';
import 'package:academic_portal/main.dart';

void main() {
  testWidgets('Academic Portal smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AcademicPortalApp());
    expect(find.byType(AcademicPortalApp), findsOneWidget);
  });
}
