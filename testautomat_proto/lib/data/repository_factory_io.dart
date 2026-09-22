import 'parkautomat_repository.dart';
import 'sqlite_repository.dart';

/// Desktop und Android: lokale SQLite-Datei des Prototyps (E-49).
ParkautomatRepository createDefaultRepository() => SqliteRepository.desktop();
