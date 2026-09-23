import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/logic/kennzeichen.dart';

void main() {
  group('Kennzeichen (Normalform und Pruefung)', () {
    test('entfernt Trenner, Leerzeichen und schreibt gross', () {
      expect(normalisiereKennzeichen(' wen ab 123 '), 'WENAB123');
      expect(normalisiereKennzeichen('b-x-1234'), 'BX1234');
      expect(normalisiereKennzeichen('WEN_AB_123'), 'WENAB123');
    });

    test('akzeptiert gueltige deutsche Kennzeichen', () {
      for (final kennzeichen in <String>[
        'AB123',
        'M1',
        'WENAB123',
        'KA1234',
        'WENAB123E',
        'AB123H',
      ]) {
        expect(
          istGueltigesKennzeichen(kennzeichen),
          isTrue,
          reason: kennzeichen,
        );
      }
    });

    test('weist ungueltige Eingaben zurueck', () {
      for (final kennzeichen in <String>['', '123', 'AB', 'AB12345']) {
        expect(
          istGueltigesKennzeichen(normalisiereKennzeichen(kennzeichen)),
          isFalse,
          reason: kennzeichen,
        );
      }
    });

    test('Trenner allein machen eine Eingabe nicht ungueltig', () {
      // Bindestriche und Leerzeichen sind zulaessige Schreibweisen.
      expect(
        istGueltigesKennzeichen(normalisiereKennzeichen('AB-123')),
        isTrue,
      );
      expect(
        istGueltigesKennzeichen(normalisiereKennzeichen('ab 123')),
        isTrue,
      );
    });
  });
}
