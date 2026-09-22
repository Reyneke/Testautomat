import 'dto.dart';

/// Zentrale Datenschnittstelle der App ("Contract first", E-04).
///
/// Alle Zugriffe der Bildschirme laufen ueber dieses Interface - auch das
/// Schreiben aus dem Debug-Bildschirm. Implementierungen: `SqliteRepository`
/// (Desktop-Prototyp), `InMemoryRepository` (Web-Build und Tests) und spaeter
/// ein `RestRepository` fuer die Produktion.
abstract class ParkautomatRepository {
  /// Liefert die aktive Maschine (im Prototyp genau eine, E-53).
  Future<Maschine> getMachine();

  /// Liefert die Preisregeln.
  Future<List<Preissetting>> getPreissettings();

  /// Liefert die Verkaufszeiten je Wochentag.
  Future<List<Verkaufszeit>> getVerkaufszeiten();

  /// Liefert Betriebsdaten im Zeitraum `[von, bis)`; `null` bedeutet offen.
  Future<List<Telemetrie>> getTelemetrie({DateTime? von, DateTime? bis});

  /// Liefert den Umsatz je UTC-Kalendertag im Zeitraum `[von, bis)`.
  Future<List<Tagesumsatz>> getTagesumsaetze(DateTime von, DateTime bis);

  /// Legt einen Verkauf atomar an und vergibt die Belegnummer (E-16).
  Future<Verkauf> createSale(VerkaufDraft draft);

  /// Aktualisiert eine Preisregel (Debug-Bildschirm).
  Future<void> updatePreissetting(Preissetting setting);

  /// Aktualisiert ein Verkaufszeit-Fenster (Debug-Bildschirm).
  Future<void> updateVerkaufszeit(Verkaufszeit zeit);

  /// Gibt Ressourcen frei (z. B. die Datenbankverbindung).
  Future<void> close();
}
