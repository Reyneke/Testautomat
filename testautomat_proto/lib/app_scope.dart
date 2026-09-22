import 'package:flutter/widgets.dart';

import 'package:testautomat_proto/data/parkautomat_repository.dart';
import 'package:testautomat_proto/state/app_state.dart';

/// Stellt den App-Zustand und das Repository dem Widget-Baum bereit (E-04/E-46).
///
/// `main.dart` erzeugt beides und veroeffentlicht es hier; die Widgets abonnieren
/// die einzelnen `ValueNotifier` des [AppState] gezielt. Tests koennen eigene
/// Instanzen uebergeben und damit isoliert arbeiten.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.zustand,
    required this.repository,
    required super.child,
  });

  /// Globaler Zustand (Theme, Sprache, Maschine, Debug-Zugang, Uhr).
  final AppState zustand;

  /// Datenzugriff fuer die Bildschirme.
  final ParkautomatRepository repository;

  /// Liefert den [AppScope] des umgebenden Widget-Baums.
  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    if (scope == null) {
      throw StateError(
        'AppScope fehlt im Widget-Baum. TestAutomatApp muss mit '
        'Zustand und Repository gestartet werden.',
      );
    }
    return scope;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      oldWidget.zustand != zustand || oldWidget.repository != repository;
}
