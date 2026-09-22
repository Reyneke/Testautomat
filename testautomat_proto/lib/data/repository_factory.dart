import 'parkautomat_repository.dart';
import 'repository_factory_web.dart'
    if (dart.library.io) 'repository_factory_io.dart'
    as impl;

/// Waehlt die Repository-Implementierung der App (Composition Root, E-04/E-11).
///
/// Web-Build: `InMemoryRepository`; Desktop und Android: `SqliteRepository`.
/// Die Entscheidung faellt genau an dieser Stelle - nicht ueber die App verteilt.
ParkautomatRepository createDefaultRepository() =>
    impl.createDefaultRepository();
