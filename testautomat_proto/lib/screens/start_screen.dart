import 'dart:async';

import 'package:flutter/material.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/widgets/language_selector.dart';
import 'package:testautomat_proto/widgets/theme_selector.dart';

/// Startbildschirm des Automaten.
///
/// Gemeinsamer Aufbau gemäß `doc/plan/grundlagen/0_Einfuehrung.md`:
/// - oben links: Uhrzeit und Datum
/// - oben rechts: Logo der Stadt Weiden
/// - mittig: uhrzeitangemessene Begrüßung und Start-Button
/// - unten links: ThemeSelector und Sprachauswahl
/// - unten rechts: Debuginformationen
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  static const String _logoAsset =
      'assets/img/DEU_Weiden_in_der_Oberpfalz_COA.svg.webp';

  // Platzhalterwerte für den Prototyp, später aus der Datenbank.
  static const String _machineNumber = '4711';
  static const String _location = 'Weiden i. d. OPf.';

  late DateTime _now;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) {
        return;
      }
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeader(localizations, theme.textTheme),
              Expanded(child: _buildCenter(localizations, theme.textTheme)),
              _buildFooter(localizations, theme.textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.formatTime(_now), style: textTheme.headlineMedium),
            Text(l10n.formatDate(_now), style: textTheme.titleMedium),
          ],
        ),
        const Spacer(),
        Semantics(
          label: l10n.appTitle,
          image: true,
          child: Image.asset(_logoAsset, height: 72, fit: BoxFit.contain),
        ),
      ],
    );
  }

  Widget _buildCenter(AppLocalizations l10n, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.greetingFor(_now),
            style: textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              // TODO: Navigation zur Parkzeitauswahl (Folgedokument).
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(l10n.startSale, style: textTheme.titleLarge),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l10n, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Links: Darstellung und Sprache. Der Wrap bricht bei zu wenig Platz
        // um, statt die Zeile überlaufen zu lassen (Barrierefreiheit/Zoom).
        Expanded(
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const [
              ThemeModeSelector(),
              LanguageSelector(),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${l10n.debugMachine}: $_machineNumber',
              style: textTheme.bodySmall,
            ),
            Text(
              '${l10n.debugLocation}: $_location',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
