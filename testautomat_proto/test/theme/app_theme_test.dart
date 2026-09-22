// Theme: gebuendelte Schriften (Poppins/Lato) statt Laufzeitabruf (E-38, U-72).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/theme/app_theme.dart';

/// Alle Stile der gemeinsamen TextTheme-Basis mit ihrem Bereich.
Map<String, TextStyle?> stilListe() => {
  'displayLarge': AppTheme.baseTextTheme.displayLarge,
  'displayMedium': AppTheme.baseTextTheme.displayMedium,
  'displaySmall': AppTheme.baseTextTheme.displaySmall,
  'headlineLarge': AppTheme.baseTextTheme.headlineLarge,
  'headlineMedium': AppTheme.baseTextTheme.headlineMedium,
  'headlineSmall': AppTheme.baseTextTheme.headlineSmall,
  'titleLarge': AppTheme.baseTextTheme.titleLarge,
  'titleMedium': AppTheme.baseTextTheme.titleMedium,
  'titleSmall': AppTheme.baseTextTheme.titleSmall,
  'bodyLarge': AppTheme.baseTextTheme.bodyLarge,
  'bodyMedium': AppTheme.baseTextTheme.bodyMedium,
  'bodySmall': AppTheme.baseTextTheme.bodySmall,
  'labelLarge': AppTheme.baseTextTheme.labelLarge,
  'labelMedium': AppTheme.baseTextTheme.labelMedium,
  'labelSmall': AppTheme.baseTextTheme.labelSmall,
};

void main() {
  group('Gebuendelte Schriften (E-38, U-72)', () {
    test('Ueberschriften tragen Poppins, Fliesstext traegt Lato', () {
      for (final eintrag in stilListe().entries) {
        expect(
          eintrag.value?.fontFamily,
          isNotNull,
          reason: '${eintrag.key} braucht eine Schriftfamilie',
        );
      }

      const ueberschriften = [
        'displayLarge',
        'displayMedium',
        'displaySmall',
        'headlineLarge',
        'headlineMedium',
        'headlineSmall',
      ];
      final stile = stilListe();
      for (final name in ueberschriften) {
        expect(
          stile[name]?.fontFamily,
          AppTheme.ueberschriftFamilie,
          reason: '$name gehoert zur Ueberschriftenschrift',
        );
      }
      for (final eintrag in stile.entries) {
        if (ueberschriften.contains(eintrag.key)) {
          continue;
        }
        expect(
          eintrag.value?.fontFamily,
          AppTheme.textFamilie,
          reason: '${eintrag.key} gehoert zur Fliesstextschrift',
        );
      }
    });

    test('die Gewichte passen zu den gebuendelten Schnitten (400/500/600)', () {
      final erlaubt = <FontWeight>{
        FontWeight.w400,
        FontWeight.w500,
        FontWeight.w600,
      };
      for (final eintrag in stilListe().entries) {
        expect(
          erlaubt.contains(eintrag.value?.fontWeight),
          isTrue,
          reason:
              '${eintrag.key} nutzt ${eintrag.value?.fontWeight}; gebuendelt '
              'sind nur 400, 500 und 600',
        );
      }
    });

    test('die Schriftdateien und Lizenzen liegen als Assets im Projekt', () {
      const dateien = <String>[
        'assets/fonts/Poppins-Regular.ttf',
        'assets/fonts/Poppins-Medium.ttf',
        'assets/fonts/Poppins-SemiBold.ttf',
        'assets/fonts/Lato-Regular.ttf',
        'assets/fonts/Lato-Medium.ttf',
        'assets/fonts/Lato-SemiBold.ttf',
        'assets/fonts/OFL-Poppins.txt',
        'assets/fonts/OFL-Lato.txt',
      ];

      for (final pfad in dateien) {
        expect(
          File(pfad).existsSync(),
          isTrue,
          reason: '$pfad fehlt (gebündelte Schrift bzw. Lizenz)',
        );
      }
    });

    test('die pubspec bindet die Familien ein und kennt kein google_fonts', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();

      expect(
        pubspec.contains('google_fonts'),
        isFalse,
        reason: 'Der Laufzeitabruf ueber google_fonts ist entfallen (E-38).',
      );
      expect(pubspec.contains('family: Poppins'), isTrue);
      expect(pubspec.contains('family: Lato'), isTrue);
    });

    test('kein Dart-Code verweist mehr auf GoogleFonts', () {
      final treffer = <String>[];

      for (final eintrag in Directory('lib').listSync(recursive: true)) {
        if (eintrag is! File || !eintrag.path.endsWith('.dart')) {
          continue;
        }
        if (eintrag.readAsStringSync().contains('GoogleFonts')) {
          treffer.add(eintrag.path);
        }
      }

      expect(
        treffer,
        isEmpty,
        reason:
            'Schriften kommen aus assets/fonts/ (kein Netzabruf, E-38/U-72).',
      );
    });
  });
}
