/// Doppelkauf-Pruefung (`7_Neue_Zahlmoeglichkeiten.md`).
///
/// Solange fuer dasselbe Kennzeichen eine Parkzeit laeuft, darf kein zweiter
/// Verkauf entstehen. Die Pruefung ist rein und wird von beiden
/// Repository-Implementierungen genutzt, damit sie identisch greift (E-04).
library;

import '../data/dto.dart';

/// Liefert den Verkauf mit [kennzeichen], dessen Parkzeit zum [kaufzeitpunkt]
/// noch nicht abgelaufen ist, sonst `null`.
///
/// Laeuft mehr als ein Ticket, wird das am spaetesten ablaufende geliefert.
Verkauf? aktivesTicket(
  Iterable<Verkauf> verkaeufe,
  String kennzeichen,
  DateTime kaufzeitpunkt,
) {
  Verkauf? treffer;
  for (final verkauf in verkaeufe) {
    if (verkauf.kennzeichen != kennzeichen) {
      continue;
    }
    if (!verkauf.gueltigBis.isAfter(kaufzeitpunkt)) {
      continue;
    }
    if (treffer == null || verkauf.gueltigBis.isAfter(treffer.gueltigBis)) {
      treffer = verkauf;
    }
  }
  return treffer;
}
