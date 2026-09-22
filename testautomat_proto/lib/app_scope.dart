import 'package:flutter/widgets.dart';

import 'data/parkautomat_repository.dart';

/// Stellt das [ParkautomatRepository] dem Widget-Baum bereit (E-04).
///
/// Die Implementierung wird in `main.dart` gewaehlt und hier veroeffentlicht,
/// damit Bildschirme nicht selbst auf die Datenquelle zugreifen.
class AppScope extends InheritedWidget {
  const AppScope({super.key, required this.repository, required super.child});

  /// Datenzugriff fuer alle Bildschirme.
  final ParkautomatRepository repository;

  /// Liefert den [AppScope] des umgebenden Widget-Baums.
  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    if (scope == null) {
      throw StateError(
        'AppScope fehlt im Widget-Baum. TestAutomatApp muss '
        'mit einem Repository gestartet werden.',
      );
    }
    return scope;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      oldWidget.repository != repository;
}
