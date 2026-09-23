import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Legt den Parkschein im Download-Verzeichnis ab (Desktop/Android).
///
/// `getDownloadsDirectory()` bedient Desktop-Systeme; auf Android ist es
/// `null`, dort greift das Dokumentverzeichnis der App. Der Prototyp meldet den
/// Zielordner zurueck, statt eine Teilen-Oberflaeche zu oeffnen.
Future<String> speichereParkschein(Uint8List bytes, String dateiname) async {
  final verzeichnis =
      await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
  final datei = File('${verzeichnis.path}${Platform.pathSeparator}$dateiname');
  await datei.writeAsBytes(bytes, flush: true);
  return datei.path;
}
