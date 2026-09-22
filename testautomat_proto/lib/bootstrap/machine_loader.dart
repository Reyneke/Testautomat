import 'dart:async';

import 'package:flutter/material.dart';

import 'package:testautomat_proto/app_scope.dart';
import 'package:testautomat_proto/data/parkautomat_repository.dart';
import 'package:testautomat_proto/logic/verkaufszeit.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/routes.dart';
import 'package:testautomat_proto/state/app_machine.dart';
import 'package:testautomat_proto/widgets/screen_shell.dart';

/// Laedt die aktive Maschine und waehlt danach den Einstieg (E-23, E-55).
///
/// Drei Zustaende: Ladebildschirm, Fehlerbildschirm "Automat ausser Betrieb"
/// (mit erneutem Versuch) und - nach erfolgreichem Laden - der Kaufablauf.
/// `getMachine()` liefert laut E-53 genau die aktive Maschine; ist keine aktiv
/// oder die Datenquelle nicht erreichbar, greift der Fehlerbildschirm (E-23).
/// Der Einstieg folgt der Verkaufszeit (E-14): ausserhalb der Verkaufszeit
/// zeigt der Automat den "Aus"-Bildschirm.
class MachineLoader extends StatefulWidget {
  const MachineLoader({super.key});

  @override
  State<MachineLoader> createState() => _MachineLoaderState();
}

enum _Ladezustand { laedt, bereit, fehler }

class _MachineLoaderState extends State<MachineLoader> {
  _Ladezustand _zustand = _Ladezustand.laedt;
  ParkautomatRepository? _repository;
  bool _verkaufMoeglich = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repository = AppScope.of(context).repository;
    if (!identical(repository, _repository)) {
      _repository = repository;
      unawaited(_laden(repository));
    }
  }

  /// Laedt Maschine und Verkaufszeit; Fehler jeder Art fuehren zum
  /// Fehlerbildschirm (E-23).
  Future<void> _laden(ParkautomatRepository repository) async {
    try {
      final maschine = await repository.getMachine();
      final fenster = await repository.getVerkaufszeiten();
      final verkaufMoeglich = istInVerkaufszeit(
        fenster: fenster,
        jetztUtc: DateTime.now(),
      );
      if (!mounted) {
        return;
      }
      AppMachine.maschineNotifier.value = maschine;
      _verkaufMoeglich = verkaufMoeglich;
      setState(() => _zustand = _Ladezustand.bereit);
    } on Object {
      if (!mounted) {
        return;
      }
      AppMachine.reset();
      setState(() => _zustand = _Ladezustand.fehler);
    }
  }

  void _erneutVersuchen() {
    final repository = _repository;
    if (repository == null) {
      return;
    }
    setState(() => _zustand = _Ladezustand.laedt);
    unawaited(_laden(repository));
  }

  @override
  Widget build(BuildContext context) {
    switch (_zustand) {
      case _Ladezustand.laedt:
        return const _Ladebildschirm();
      case _Ladezustand.fehler:
        return _Fehlerbildschirm(onErneutVersuchen: _erneutVersuchen);
      case _Ladezustand.bereit:
        return Navigator(
          initialRoute: _verkaufMoeglich ? AppRoutes.start : AppRoutes.aus,
          // Nur eine Einstiegsroute aufbauen (der Standard wuerde zusaetzlich
          // "/" erzeugen und den Startbildschirm doppelt stapeln).
          onGenerateInitialRoutes: (navigator, initialRoute) => <Route<void>>[
            AppRoutes.onGenerateRoute(
              RouteSettings(name: initialRoute),
              onNeuLaden: _erneutVersuchen,
            ),
          ],
          onGenerateRoute: (settings) =>
              AppRoutes.onGenerateRoute(settings, onNeuLaden: _erneutVersuchen),
        );
    }
  }
}

class _Ladebildschirm extends StatelessWidget {
  const _Ladebildschirm();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ScreenShell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(localizations.ladeMaschine),
          ],
        ),
      ),
    );
  }
}

class _Fehlerbildschirm extends StatelessWidget {
  const _Fehlerbildschirm({required this.onErneutVersuchen});

  final VoidCallback onErneutVersuchen;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    return ScreenShell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.automatAusserBetrieb,
              style: textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              localizations.automatAusserBetriebHinweis,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: onErneutVersuchen,
              child: Text(localizations.erneutVersuchen),
            ),
          ],
        ),
      ),
    );
  }
}
