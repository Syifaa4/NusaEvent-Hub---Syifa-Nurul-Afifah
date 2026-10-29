import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_sesi_5/main.dart';

void main() {
  testWidgets('menampilkan halaman Seminar', (tester) async {
    await tester.pumpWidget(const NusaEventHubApp());
    expect(find.text('NusaEvent Hub'), findsOneWidget);
    expect(find.text('Seminar'), findsOneWidget);
  });
}