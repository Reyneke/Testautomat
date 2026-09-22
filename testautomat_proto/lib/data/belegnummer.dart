import 'json_utils.dart';

/// Vergibt Belegnummern nach E-16: Hash aus Geraete-ID, Zaehler und Einschaltzeit.
///
/// Ohne zentrale Vergabe eindeutig: Innerhalb einer Einschaltzeit steigt die
/// Nummer streng monoton, ueber Neustarts hinweg unterscheidet sie sich ueber die
/// Einschaltzeit. Die Nummer bleibt unter 2^53, damit sie in JSON ohne
/// Praezisionsverlust uebertragbar ist.
class BelegnummerGenerator {
  factory BelegnummerGenerator({
    required String geraeteId,
    DateTime? einschaltzeit,
    int startZaehler = 0,
  }) {
    final zeit = truncateToSecondsUtc(einschaltzeit ?? DateTime.now());
    return BelegnummerGenerator._(
      geraeteId,
      zeit,
      hashBasis(geraeteId, zeit),
      startZaehler,
    );
  }

  BelegnummerGenerator._(
    this.geraeteId,
    this.einschaltzeit,
    this._basis,
    this._zaehler,
  );

  /// Groesste exakt als JSON-Zahl darstellbare Belegnummer (2^53 - 1).
  static const int maxBelegnummer = 9007199254740991;

  /// Blockgroesse je Basishash (Zaehler wird einfach aufaddiert).
  static const int _blockGroesse = 1000000;

  /// Lesbare Geraete-ID des Automaten, z. B. `4711`.
  final String geraeteId;

  /// Zeitpunkt des App-/Repository-Starts (UTC, sekundengenau).
  final DateTime einschaltzeit;

  final int _basis;
  int _zaehler;

  /// Bereits vergebene Nummern (dient als Startwert nach einem Neustart).
  int get zaehler => _zaehler;

  /// Liefert die naechste Belegnummer; jede Nummer wird nur einmal vergeben.
  int next() {
    final nummer = _basis * _blockGroesse + _zaehler;
    _zaehler += 1;
    return nummer;
  }

  /// Modularer Polynom-Hash (Basis 31, Modul 2^31 - 1).
  ///
  /// Bleibt auf allen Plattformen exakt (auch in JavaScript), weil keine
  /// Zwischenrechnung 2^53 ueberschreitet.
  static int hashBasis(String geraeteId, DateTime einschaltzeit) {
    final eingabe = '$geraeteId|${einschaltzeit.millisecondsSinceEpoch}';
    var hash = 0;
    for (final unit in eingabe.codeUnits) {
      hash = (hash * 31 + unit) % 2147483647;
    }
    return hash;
  }
}
