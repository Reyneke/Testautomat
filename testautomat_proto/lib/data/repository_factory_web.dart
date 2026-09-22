import 'in_memory_repository.dart';
import 'parkautomat_repository.dart';

/// Web-Build: der Browser hat kein Dateisystem, daher InMemory (E-11).
ParkautomatRepository createDefaultRepository() => InMemoryRepository();
