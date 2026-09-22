import 'package:flutter/material.dart';

import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Verabschiedung nach dem (simulierten) Kauf (`0_Einfuehrung.md`).
class VerabschiedungScreen extends StatelessWidget {
  const VerabschiedungScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return ScreenShell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.verabschiedungTitle,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.verabschiedungText,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(AppRoutes.start, (route) => false),
              child: Text(localizations.neuerVerkauf),
            ),
          ],
        ),
      ),
    );
  }
}
