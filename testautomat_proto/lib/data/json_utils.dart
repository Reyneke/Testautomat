/// Hilfsfunktionen fuer den JSON-Vertrag des Datenlayers.
///
/// Feldnamen sind im JSON `snake_case`, Zeitstempel ISO-8601 in UTC und
/// Geldbetraege ganze Cent. Siehe `doc/plan/grundlagen/2_Datenbank.md`.
library;

/// Liest ein Pflichtfeld vom Typ `int`.
int jsonInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  throw FormatException('Feld "$key" ist keine Zahl: $value');
}

/// Liest ein Pflichtfeld vom Typ `String`.
String jsonString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) {
    return value;
  }
  throw FormatException('Feld "$key" ist kein Text: $value');
}

/// Liest ein Pflichtfeld als UTC-Zeitpunkt (ISO-8601).
DateTime jsonUtcDateTime(Map<String, dynamic> json, String key) =>
    _parseUtc(jsonString(json, key), key);

/// Liest ein optionales Feld als UTC-Zeitpunkt (ISO-8601); `null` bleibt `null`.
DateTime? jsonUtcDateTimeOrNull(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is! String) {
    throw FormatException('Feld "$key" ist kein ISO-8601-Zeitstempel: $value');
  }
  return _parseUtc(value, key);
}

DateTime _parseUtc(String value, String key) {
  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    throw FormatException('Feld "$key" ist kein ISO-8601-Zeitstempel: $value');
  }
  return truncateToSecondsUtc(parsed);
}

/// Normalisiert einen Zeitpunkt auf volle Sekunden in UTC.
DateTime truncateToSecondsUtc(DateTime value) {
  final utc = value.toUtc();
  return DateTime.utc(
    utc.year,
    utc.month,
    utc.day,
    utc.hour,
    utc.minute,
    utc.second,
  );
}

/// Formatiert einen Zeitpunkt als ISO-8601-Text in UTC, z. B. `2026-09-18T10:42:00Z`.
String formatUtc(DateTime value) {
  final iso = truncateToSecondsUtc(value).toIso8601String();
  return '${iso.substring(0, 19)}Z';
}

/// Formatiert einen optionalen Zeitpunkt; `null` bleibt `null`.
String? formatUtcOrNull(DateTime? value) =>
    value == null ? null : formatUtc(value);

/// Liefert den UTC-Kalendertag eines Zeitpunkts als `YYYY-MM-DD`.
String formatUtcDay(DateTime value) => formatUtc(value).substring(0, 10);
