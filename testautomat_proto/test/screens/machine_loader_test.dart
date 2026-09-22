// Lade-, Erfolgs- und Fehlerpfad des Bootstraps (E-23, E-53, E-55).

import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/in_memory_repository.dart';
import 'package:testautomat_proto/data/repository_exception.dart';
import 'package:testautomat_proto/main.dart';
import 'package:testautomat_proto/state/app_state.dart';

import '../support/app_test_helpers.dart';

/// Repository, das beim ersten Aufruf scheitert (Datenquelle nicht erreichbar).
class _ErstFehlerRepository extends InMemoryRepository {
  int aufrufe = 0;

  @override
  Future<Maschine> getMachine() async {
    aufrufe += 1;
    if (aufrufe == 1) {
      throw const RepositoryException('Datenquelle nicht erreichbar.');
    }
    return super.getMachine();
  }
}

/// Repository mit einer Maschine, die nicht aktiv ist.
///
/// `getMachine()` liefert laut E-53 nur die aktive Maschine und scheitert hier -
/// der Prototyp zeigt deshalb den Fehlerbildschirm (E-23).
InMemoryRepository _ohneAktiveMaschine() => InMemoryRepository(
  maschinen: <Maschine>[
    const Maschine(
      id: 1,
      geraeteId: '4711',
      standort: 'Weiden i. d. OPf.',
      status: MaschinenStatus.inaktiv,
      kundennummer: 'K-0001',
    ),
  ],
);

void main() {
  testWidgets('zeigt waehrend des Ladens den Ladebildschirm', (tester) async {
    await tester.pumpWidget(
      TestAutomatApp(zustand: AppState(), repository: InMemoryRepository()),
    );

    expect(find.text('Automat wird gestartet …'), findsOneWidget);

    await tester.pump();
    await tester.pump();
    expect(find.text('Verkauf starten'), findsOneWidget);

    await beendeApp(tester);
  });

  testWidgets('aktive Maschine fuehrt zum Startbildschirm', (tester) async {
    final zustand = await pumpeApp(tester, repository: InMemoryRepository());

    expect(find.text('Verkauf starten'), findsOneWidget);
    expect(zustand.maschine.value?.status, MaschinenStatus.aktiv);

    await beendeApp(tester);
  });

  testWidgets('Maschine ohne aktiven Status fuehrt zum Fehlerbildschirm', (
    tester,
  ) async {
    final zustand = await pumpeApp(tester, repository: _ohneAktiveMaschine());

    expect(find.text('Automat außer Betrieb'), findsOneWidget);
    expect(find.text('Verkauf starten'), findsNothing);
    expect(zustand.maschine.value, isNull);

    await beendeApp(tester);
  });

  testWidgets('Fehler beim Laden zeigt einen Fehlerbildschirm', (tester) async {
    final zustand = await pumpeApp(tester, repository: _ErstFehlerRepository());

    expect(find.text('Automat außer Betrieb'), findsOneWidget);
    expect(find.text('Erneut versuchen'), findsOneWidget);
    expect(find.text('Verkauf starten'), findsNothing);
    expect(zustand.maschine.value, isNull);

    await beendeApp(tester);
  });

  testWidgets('Erneut versuchen laedt die Maschine neu', (tester) async {
    final repository = _ErstFehlerRepository();
    final zustand = await pumpeApp(tester, repository: repository);
    expect(find.text('Automat außer Betrieb'), findsOneWidget);

    await tester.tap(find.text('Erneut versuchen'));
    await tester.pump();
    await tester.pump();

    expect(repository.aufrufe, 2);
    expect(find.text('Verkauf starten'), findsOneWidget);
    expect(zustand.maschine.value?.geraeteId, '4711');

    await beendeApp(tester);
  });
}
