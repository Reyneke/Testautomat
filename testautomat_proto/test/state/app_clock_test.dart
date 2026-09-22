// Uhr: 30-Sekunden-Takt und Pause im Hintergrund (E-26, E-27, U-71).

import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/state/app_state.dart';

void main() {
  late AppClock uhr;

  setUp(() => uhr = AppClock());
  tearDown(() => uhr.dispose());

  group('Uhr-Takt (E-26)', () {
    test('laeuft, sobald ein Nutzer angemeldet ist', () {
      expect(uhr.laeuft, isFalse);
      uhr.start();
      expect(uhr.laeuft, isTrue);
      expect(uhr.pausiert, isFalse);
    });

    test('stoppt beim letzten Nutzer', () {
      uhr.start();
      uhr.start();
      uhr.stop();
      expect(uhr.laeuft, isTrue, reason: 'ein Nutzer ist noch aktiv');
      uhr.stop();
      expect(uhr.laeuft, isFalse);
    });
  });

  group('Pause im Hintergrund (E-27)', () {
    test('pausieren haelt den Takt an', () {
      uhr.start();
      uhr.pausieren();

      expect(uhr.pausiert, isTrue);
      expect(uhr.laeuft, isFalse, reason: 'im Hintergrund laeuft kein Timer');
    });

    test('fortsetzen aktualisiert sofort und taktet weiter', () {
      uhr.start();
      uhr.pausieren();
      uhr.notifier.value = DateTime(2020);

      uhr.fortsetzen();

      expect(uhr.pausiert, isFalse);
      expect(uhr.laeuft, isTrue);
      expect(
        uhr.notifier.value.year,
        DateTime.now().year,
        reason: 'beim Zurueckkommen ist die Anzeige sofort korrekt',
      );
    });

    test('im Hintergrund startet kein Timer', () {
      uhr.pausieren();
      uhr.start();

      expect(uhr.laeuft, isFalse);

      uhr.fortsetzen();
      expect(uhr.laeuft, isTrue);
    });

    test('ohne Nutzer laeuft auch nach dem Zurueckkommen nichts', () {
      uhr.pausieren();
      uhr.fortsetzen();

      expect(uhr.laeuft, isFalse);
      expect(uhr.pausiert, isFalse);
    });

    test('reset loest die Pause', () {
      uhr.start();
      uhr.pausieren();
      uhr.reset();

      expect(uhr.pausiert, isFalse);
      expect(uhr.laeuft, isFalse);
    });
  });
}
