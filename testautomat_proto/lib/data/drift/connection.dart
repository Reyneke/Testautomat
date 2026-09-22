import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Name der SQLite-Datei des Prototyps.
const String datenbankName = 'testautomat';

/// Oeffnet die lokale SQLite-Datei im plattformueblichen Datenverzeichnis.
///
/// Die Verbindung wird verzögert geoeffnet und schliesst die Verbindung beim
/// Beenden der App wieder. Siehe `doc/plan/grundlagen/2_Datenbank.md`.
QueryExecutor openAppDatabase() => driftDatabase(name: datenbankName);
