import 'package:flutter_test/flutter_test.dart';

import 'package:glovex_liquid_ui_showcase/main.dart';

void main() {
  testWidgets('showcase app renders', (tester) async {
    await tester.pumpWidget(const ShowcaseApp());
    expect(find.textContaining('glovex_liquid_ui'), findsOneWidget);
  });
}
