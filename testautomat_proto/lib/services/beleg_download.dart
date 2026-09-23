/// Stellt den erzeugten Parkschein zum Herunterladen bereit
/// (`7_Neue_Zahlmoeglichkeiten.md`).
///
/// Der Web-Build loest einen echten Browser-Download aus; die uebrigen
/// Plattformen legen die Datei im Download-Verzeichnis ab. Die Konfiguration
/// liegt an genau einer Stelle (Composition-Root-Muster wie
/// `repository_factory.dart`, E-04/E-11).
library;

import 'dart:typed_data';

import 'beleg_download_web.dart'
    if (dart.library.io) 'beleg_download_io.dart'
    as impl;

/// Speichert [bytes] unter [dateiname] und liefert einen Hinweis fuer die
/// Oberflaeche (Web: Dateiname, sonst: voller Pfad).
Future<String> speichereParkschein(Uint8List bytes, String dateiname) =>
    impl.speichereParkschein(bytes, dateiname);
