import 'package:flutter/material.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/l10n/app_localizations.dart';
import 'package:testautomat_proto/logic/verkaufszeit.dart';

/// Dialog zum Bearbeiten einer Preisregel (U-43, E-04).
///
/// Liefert die geänderte [Preissetting] über `Navigator.pop`; die
/// Gültigkeitszeiträume bleiben unverändert (Datumswahl folgt später).
class PreissettingDialog extends StatefulWidget {
  const PreissettingDialog({super.key, required this.vorlage});

  /// Aktuelle Werte, die bearbeitet werden.
  final Preissetting vorlage;

  @override
  State<PreissettingDialog> createState() => _PreissettingDialogState();
}

class _PreissettingDialogState extends State<PreissettingDialog> {
  late final TextEditingController _takt = TextEditingController(
    text: '${widget.vorlage.taktMinuten}',
  );
  late final TextEditingController _preis = TextEditingController(
    text: '${widget.vorlage.preisProTaktCent}',
  );
  late final TextEditingController _waehrung = TextEditingController(
    text: widget.vorlage.waehrung,
  );
  String? _fehler;

  @override
  void dispose() {
    _takt.dispose();
    _preis.dispose();
    _waehrung.dispose();
    super.dispose();
  }

  void _speichern() {
    final localizations = AppLocalizations.of(context);
    final takt = int.tryParse(_takt.text.trim());
    final preis = int.tryParse(_preis.text.trim());
    if (takt == null || takt <= 0 || preis == null || preis < 0) {
      setState(() => _fehler = localizations.debugUngueltigeEingabe);
      return;
    }
    Navigator.of(context).pop(
      Preissetting(
        id: widget.vorlage.id,
        taktMinuten: takt,
        preisProTaktCent: preis,
        waehrung: _waehrung.text.trim(),
        gueltigVon: widget.vorlage.gueltigVon,
        gueltigBis: widget.vorlage.gueltigBis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.debugPreissettings),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _takt,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.debugTaktMinuten,
              ),
            ),
            TextField(
              controller: _preis,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.debugPreisProTaktCent,
              ),
            ),
            TextField(
              controller: _waehrung,
              decoration: InputDecoration(
                labelText: localizations.debugWaehrung,
              ),
            ),
            if (_fehler != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _fehler!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.debugAbbrechen),
        ),
        FilledButton(
          onPressed: _speichern,
          child: Text(localizations.debugSpeichern),
        ),
      ],
    );
  }
}

/// Dialog zum Bearbeiten eines Verkaufszeit-Fensters (U-43, E-04).
class VerkaufszeitDialog extends StatefulWidget {
  const VerkaufszeitDialog({super.key, required this.vorlage});

  /// Aktuelle Werte, die bearbeitet werden.
  final Verkaufszeit vorlage;

  @override
  State<VerkaufszeitDialog> createState() => _VerkaufszeitDialogState();
}

class _VerkaufszeitDialogState extends State<VerkaufszeitDialog> {
  late final TextEditingController _wochentag = TextEditingController(
    text: '${widget.vorlage.wochentag}',
  );
  late final TextEditingController _beginn = TextEditingController(
    text: widget.vorlage.beginn,
  );
  late final TextEditingController _ende = TextEditingController(
    text: widget.vorlage.ende,
  );
  String? _fehler;

  @override
  void dispose() {
    _wochentag.dispose();
    _beginn.dispose();
    _ende.dispose();
    super.dispose();
  }

  void _speichern() {
    final localizations = AppLocalizations.of(context);
    final wochentag = int.tryParse(_wochentag.text.trim());
    final beginn = _beginn.text.trim();
    final ende = _ende.text.trim();
    if (wochentag == null ||
        wochentag < DateTime.monday ||
        wochentag > DateTime.sunday ||
        !istGueltigesHhMm(beginn) ||
        !istGueltigesHhMm(ende) ||
        ende.compareTo(beginn) <= 0) {
      setState(() => _fehler = localizations.debugUngueltigeEingabe);
      return;
    }
    Navigator.of(context).pop(
      Verkaufszeit(
        id: widget.vorlage.id,
        wochentag: wochentag,
        beginn: beginn,
        ende: ende,
        gueltigVon: widget.vorlage.gueltigVon,
        gueltigBis: widget.vorlage.gueltigBis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(localizations.debugVerkaufszeiten),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _wochentag,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.debugWochentag,
              ),
            ),
            TextField(
              controller: _beginn,
              decoration: InputDecoration(labelText: localizations.debugBeginn),
            ),
            TextField(
              controller: _ende,
              decoration: InputDecoration(labelText: localizations.debugEnde),
            ),
            if (_fehler != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _fehler!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.debugAbbrechen),
        ),
        FilledButton(
          onPressed: _speichern,
          child: Text(localizations.debugSpeichern),
        ),
      ],
    );
  }
}
