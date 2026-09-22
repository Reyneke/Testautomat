import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Startbildschirm des Automaten (`0_Einfuehrung.md`).
///
/// Zeigt die uhrzeitangemessene Begruessung (Takt aus dem `AppState`, E-26) und
/// startet mit dem Knopf den Verkauf. Automatennummer und Standort kommen in der
/// Fusszeile aus dem `AppState` (E-55) - keine hartkodierten Werte.
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final uhr = AppScope.of(context).zustand.clock;

    return ScreenShell(
      child: ValueListenableBuilder<DateTime>(
        valueListenable: uhr.notifier,
        builder: (context, jetzt, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.greetingFor(jetzt),
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.parkzeit),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Text(
                    localizations.startSale,
                    style: textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
