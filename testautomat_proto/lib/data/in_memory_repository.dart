import '../logic/belegnummer.dart';
import '../logic/doppelkauf.dart';
import 'dto.dart';
import 'json_utils.dart';
import 'parkautomat_repository.dart';
import 'repository_exception.dart';
import 'sale_validation.dart';
import 'seed_data.dart';

/// Repository im Arbeitsspeicher (Web-Build und Tests, E-11).
///
/// Enthaelt dieselben Seed-Daten wie die SQLite-Variante, aber ohne Persistenz:
/// Aenderungen gelten nur, solange die App laeuft.
class InMemoryRepository implements ParkautomatRepository {
  InMemoryRepository({
    List<Maschine>? maschinen,
    List<Preissetting>? preissettings,
    List<Verkaufszeit>? verkaufszeiten,
    List<Parkzone>? parkzonen,
    List<Telemetrie>? telemetrie,
    List<Verkauf>? verkaeufe,
    DateTime? einschaltzeit,
  }) : _maschinen = List<Maschine>.of(maschinen ?? SeedData.maschinen()),
       _preissettings = List<Preissetting>.of(
         preissettings ?? SeedData.preissettings(),
       ),
       _verkaufszeiten = List<Verkaufszeit>.of(
         verkaufszeiten ?? SeedData.verkaufszeiten(),
       ),
       _parkzonen = List<Parkzone>.of(parkzonen ?? SeedData.parkzonen()),
       _telemetrie = List<Telemetrie>.of(telemetrie ?? SeedData.telemetrie()),
       _verkaeufe = List<Verkauf>.of(verkaeufe ?? SeedData.verkaeufe()),
       _einschaltzeit = einschaltzeit ?? DateTime.now();

  final List<Maschine> _maschinen;
  final List<Preissetting> _preissettings;
  final List<Verkaufszeit> _verkaufszeiten;
  final List<Parkzone> _parkzonen;
  final List<Telemetrie> _telemetrie;
  final List<Verkauf> _verkaeufe;
  final Map<int, BelegnummerGenerator> _generatoren =
      <int, BelegnummerGenerator>{};
  final DateTime _einschaltzeit;

  /// Anzahl der Versuche, eine freie Belegnummer zu vergeben.
  static const int maxBelegnummerVersuche = 5;

  @override
  Future<Maschine> getMachine() async {
    for (final maschine in _maschinen) {
      if (maschine.status == MaschinenStatus.aktiv) {
        return maschine;
      }
    }
    throw const RepositoryException('Keine aktive Maschine vorhanden.');
  }

  @override
  Future<List<Preissetting>> getPreissettings() async =>
      List<Preissetting>.unmodifiable(_preissettings);

  @override
  Future<List<Verkaufszeit>> getVerkaufszeiten() async =>
      List<Verkaufszeit>.unmodifiable(_verkaufszeiten);

  @override
  Future<List<Parkzone>> getParkzonen() async =>
      List<Parkzone>.unmodifiable(_parkzonen);

  @override
  Future<List<Verkauf>> getVerkaeufeZuKennzeichen(String kennzeichen) async =>
      List<Verkauf>.unmodifiable(
        _verkaeufe.where((verkauf) => verkauf.kennzeichen == kennzeichen),
      );

  @override
  Future<List<Telemetrie>> getTelemetrie({DateTime? von, DateTime? bis}) async {
    final treffer =
        _telemetrie
            .where((messwert) => _imZeitraum(messwert.timestamp, von, bis))
            .toList()
          ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return List<Telemetrie>.unmodifiable(treffer);
  }

  @override
  Future<List<Tagesumsatz>> getTagesumsaetze(DateTime von, DateTime bis) async {
    final summen = <String, int>{};
    for (final verkauf in _verkaeufe) {
      if (_imZeitraum(verkauf.timestamp, von, bis)) {
        final tag = formatUtcDay(verkauf.timestamp);
        summen.update(
          tag,
          (wert) => wert + verkauf.betragCent,
          ifAbsent: () => verkauf.betragCent,
        );
      }
    }
    final tage = summen.keys.toList()..sort();
    return List<Tagesumsatz>.unmodifiable(
      tage.map((tag) => Tagesumsatz(tag: tag, umsatzCent: summen[tag]!)),
    );
  }

  @override
  Future<Verkauf> createSale(VerkaufDraft draft) async {
    final geprueft = validateVerkaufDraft(draft);
    final maschine = _maschineMitId(geprueft.maschineId);
    _pruefeDoppelkauf(geprueft);
    final verkauf = Verkauf(
      id: _naechsteVerkaufsId(),
      maschineId: maschine.id,
      timestamp: truncateToSecondsUtc(geprueft.timestamp),
      parkdauerMinuten: geprueft.parkdauerMinuten,
      betragCent: geprueft.betragCent,
      zahlungsart: geprueft.zahlungsart,
      belegnummer: _naechsteBelegnummer(maschine),
      kennzeichen: geprueft.kennzeichen,
    );
    _verkaeufe.add(verkauf);
    return verkauf;
  }

  /// Verhindert einen zweiten Verkauf auf dasselbe, noch gueltige Kennzeichen.
  void _pruefeDoppelkauf(VerkaufDraft draft) {
    final kennzeichen = draft.kennzeichen;
    if (kennzeichen == null) {
      return;
    }
    final aktiv = aktivesTicket(_verkaeufe, kennzeichen, draft.timestamp);
    if (aktiv != null) {
      throw RepositoryException(
        'Doppelkauf: Fuer $kennzeichen laeuft bereits ein Parkschein '
        '(Belegnummer ${aktiv.belegnummer}).',
      );
    }
  }

  @override
  Future<void> updatePreissetting(Preissetting setting) async {
    final index = _preissettings.indexWhere(
      (eintrag) => eintrag.id == setting.id,
    );
    if (index < 0) {
      throw RepositoryException('Preissetting ${setting.id} existiert nicht.');
    }
    _preissettings[index] = setting;
  }

  @override
  Future<void> updateVerkaufszeit(Verkaufszeit zeit) async {
    final index = _verkaufszeiten.indexWhere(
      (eintrag) => eintrag.id == zeit.id,
    );
    if (index < 0) {
      throw RepositoryException('Verkaufszeit ${zeit.id} existiert nicht.');
    }
    _verkaufszeiten[index] = zeit;
  }

  @override
  Future<void> close() async {}

  Maschine _maschineMitId(int id) {
    for (final maschine in _maschinen) {
      if (maschine.id == id) {
        return maschine;
      }
    }
    throw RepositoryException('Unbekannte Maschine: $id');
  }

  /// Vergibt eine noch freie Belegnummer (E-16).
  int _naechsteBelegnummer(Maschine maschine) {
    for (var versuch = 0; versuch < maxBelegnummerVersuche; versuch++) {
      final nummer = _generatorFuer(maschine).next();
      if (!_verkaeufe.any((verkauf) => verkauf.belegnummer == nummer)) {
        return nummer;
      }
    }
    throw const RepositoryException(
      'Es konnte keine freie Belegnummer vergeben werden.',
    );
  }

  int _naechsteVerkaufsId() {
    var hoechste = 0;
    for (final verkauf in _verkaeufe) {
      if (verkauf.id > hoechste) {
        hoechste = verkauf.id;
      }
    }
    return hoechste + 1;
  }

  BelegnummerGenerator _generatorFuer(Maschine maschine) =>
      _generatoren.putIfAbsent(
        maschine.id,
        () => BelegnummerGenerator(
          geraeteId: maschine.geraeteId,
          einschaltzeit: _einschaltzeit,
          startZaehler: _verkaeufe
              .where((v) => v.maschineId == maschine.id)
              .length,
        ),
      );

  bool _imZeitraum(DateTime wert, DateTime? von, DateTime? bis) {
    if (von != null && wert.isBefore(von)) {
      return false;
    }
    if (bis != null && !wert.isBefore(bis)) {
      return false;
    }
    return true;
  }
}
