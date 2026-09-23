/// Regeln fuer das Kfz-Kennzeichen (`7_Neue_Zahlmoeglichkeiten.md`).
///
/// Der Kunde kann sein Kennzeichen freiwillig angeben; gespeichert wird es in
/// Normalform (Grossbuchstaben, ohne Trenner und Leerzeichen). Die Pruefung ist
/// bewusst grosszuegig: deutsche Kennzeichen aus 1-3 Buchstaben Ortskennung,
/// 1-2 Buchstaben und 1-4 Ziffern, optional mit `E` (Elektro) oder `H`
/// (Historisch). Kennzeichen sind personenbeziehbar und werden deshalb nie
/// protokolliert (`6_Logging_und_Datenschutz.md`).
library;

final RegExp _muster = RegExp(r'^[A-ZÄÖÜ]{1,3}[A-Z]{0,2}[0-9]{1,4}[EH]?$');

/// Bringt eine Eingabe in die Normalform (Grossbuchstaben, keine Trenner).
///
/// Leerzeichen, Bindestriche und Unterstriche werden entfernt, sodass
/// `b - x y 1234` und `BXY1234` dieselbe Normalform ergeben.
String normalisiereKennzeichen(String eingabe) =>
    eingabe.toUpperCase().replaceAll(RegExp(r'[\s\-_]'), '');

/// Prueft ein Kennzeichen in Normalform (siehe [normalisiereKennzeichen]).
bool istGueltigesKennzeichen(String kennzeichen) =>
    _muster.hasMatch(kennzeichen);
