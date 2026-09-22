import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/state/app_state.dart';

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
  AppClock? _uhr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uhr = AppScope.of(context).zustand.clock;
    if (!identical(uhr, _uhr)) {
      _uhr?.stop();
      _uhr = uhr;
      uhr.start();
    }
  }

  @override
  void dispose() {
    _uhr?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final uhr = AppScope.of(context).zustand.clock;

    return ValueListenableBuilder<DateTime>(
      valueListenable: uhr.notifier,
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
