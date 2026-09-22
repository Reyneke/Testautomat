import 'package:flutter/material.dart';

import 'package:testautomat_proto/theme/app_motion.dart';

/// Fortschrittsanzeige, die "Bewegung reduzieren" respektiert (E-24).
///
/// Ohne reduzierte Bewegung sind die Anzeigen wie gewohnt animiert. Ist die
/// Systemeinstellung gesetzt, laeuft nichts mehr:
/// * bestimmte Werte werden als stillstehender Balken gezeigt,
/// * unbestimmte Anzeigen durch einen ruhigen Ring ersetzt.
///
/// Die Groesse bleibt dabei gleich, damit das Layout nicht springt.
class FortschrittsAnzeige extends StatelessWidget {
  const FortschrittsAnzeige({super.key, this.wert, this.groesse = 36});

  /// Fortschritt zwischen 0 und 1; `null` steht fuer "unbestimmt" (laeuft).
  final double? wert;

  /// Durchmesser der unbestimmten Anzeige.
  final double groesse;

  @override
  Widget build(BuildContext context) {
    final ruhig = !AppMotion.erlaubt();

    if (wert == null) {
      if (ruhig) {
        return SizedBox(
          width: groesse,
          height: groesse,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 3,
              ),
            ),
          ),
        );
      }
      return CircularProgressIndicator();
    }

    if (ruhig) {
      // Ruhiger Balken: derselbe Wert, aber ohne Uebergang und ohne Animation.
      final schema = Theme.of(context).colorScheme;
      final anteil = wert!.clamp(0.0, 1.0);
      return Semantics(
        value: '${(anteil * 100).round()} %',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 4,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: schema.surfaceContainerHighest),
                ),
                FractionallySizedBox(
                  widthFactor: anteil,
                  heightFactor: 1,
                  child: ColoredBox(color: schema.primary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return LinearProgressIndicator(value: wert);
  }
}
