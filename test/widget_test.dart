import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_physio/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: SmartPhysioApp()),
    );
    // Verify splash screen shows app name
    expect(find.text('Smart Physio'), findsOneWidget);
  });
}
