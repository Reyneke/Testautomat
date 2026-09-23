import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/logic/parkschein_pdf.dart';

void main() {
  group('Parkschein als PDF', () {
    test('erzeugt ein PDF-Dokument mit den uebergebenen Zeilen', () async {
      final bytes = await parkscheinPdf(
        titel: 'Parkschein',
        zeilen: const <ParkscheinZeile>[
          ParkscheinZeile('Belegnummer', '4711'),
          ParkscheinZeile('Kennzeichen', 'WENAB123'),
          ParkscheinZeile('Zahlungsart', 'PayPal'),
        ],
      );

      expect(bytes.length, greaterThan(500));
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });
  });
}
