import 'package:flutter/material.dart';

import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/state/app_clock.dart';

/// Kopfzeile aller Bildschirme (E-21).
///
/// Links Uhrzeit und Datum (Takt aus [AppClock], E-26), rechts das Logo der
/// Stadt Weiden mit Semantik-Label. Siehe `doc/plan/grundlagen/0_Einfuehrung.md`.
class AppHeader extends StatefulWidget {
  const AppHeader({super.key});

  /// Logo der Stadt Weiden (liegt in `assets/img/`).
  static const String logoAsset =
      'assets/img/DEU_Weiden_in_der_Oberpfalz_COA.svg.webp';

  /// Hoehe des Logos.
  static const double logoHoehe = 72;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  void initState() {
    super.initState();
    AppClock.start();
  }

  @override
  void dispose() {
    AppClock.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<DateTime>(
      valueListenable: AppClock.notifier,
      builder: (context, jetzt, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.formatTime(jetzt),
                style: textTheme.headlineMedium,
              ),
              Text(
                localizations.formatDate(jetzt),
                style: textTheme.titleMedium,
              ),
            ],
          ),
          const Spacer(),
          Semantics(
            label: localizations.appTitle,
            image: true,
            child: Image.asset(
              AppHeader.logoAsset,
              height: AppHeader.logoHoehe,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
