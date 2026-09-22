// Kontrastnachweis des Farbschemas gegen WCAG 2.1 AA (E-40, U-71).
//
// Die Messwerte werden zusaetzlich ausgegeben; die Tabelle in
// doc/plan/grundlagen/1_Frontendstruktur.md stammt aus diesem Lauf.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/theme/app_theme.dart';

/// Kontrastverhaeltnis nach WCAG 2.1 (Formel mit relativer Luminanz).
double kontrast(Color vorne, Color hinten) {
  final hell = vorne.computeLuminance();
  final dunkel = hinten.computeLuminance();
  final heller = hell > dunkel ? hell : dunkel;
  final dunkler = hell > dunkel ? dunkel : hell;
  return (heller + 0.05) / (dunkler + 0.05);
}

/// Farbpaare, die im Automaten als Text auf Flaeche vorkommen.
List<(String, Color, Color)> paare(ColorScheme schema) => [
  ('primary/onPrimary', schema.onPrimary, schema.primary),
  (
    'primaryContainer/onPrimaryContainer',
    schema.onPrimaryContainer,
    schema.primaryContainer,
  ),
  ('secondary/onSecondary', schema.onSecondary, schema.secondary),
  ('surface/onSurface', schema.onSurface, schema.surface),
  ('error/onError', schema.onError, schema.error),
];

void main() {
  const mindestens = 4.5;

  for (final eintrag in <String, ThemeData>{
    'hell': AppTheme.lightTheme,
    'dunkel': AppTheme.darkTheme,
  }.entries) {
    group('Kontrast ${eintrag.key} (WCAG AA, E-40)', () {
      test('alle Textpaare erreichen mindestens 4,5:1', () {
        final schema = eintrag.value.colorScheme;
        final ergebnis = <String>[];

        for (final paar in paare(schema)) {
          final wert = kontrast(paar.$2, paar.$3);
          ergebnis.add(
            '${eintrag.key} ${paar.$1}: ${wert.toStringAsFixed(2)}:1',
          );
          expect(
            wert,
            greaterThanOrEqualTo(mindestens),
            reason: '${eintrag.key} ${paar.$1} liegt unter 4,5:1',
          );
        }

        // Bezug fuer die Tabelle in der Dokumentation.
        // ignore: avoid_print
        print('Kontrastmessung:\n  ${ergebnis.join('\n  ')}');
      });

      test('der Seed ist das dunkle Blau aus E-40', () {
        expect(AppTheme.seedColor, const Color(0xFF0D47A1));
      });
    });
  }
}
