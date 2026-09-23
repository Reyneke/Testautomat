/// Erzeugt den Parkschein als PDF (`7_Neue_Zahlmoeglichkeiten.md`).
///
/// Bewusst frei von Flutter und Lokalisierung: Beschriftungen und Werte kommen
/// fertig formatiert herein, damit die Funktion in Tests direkt pruefbar ist.
library;

import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Eine Zeile des Parkscheins (Beschriftung links, Wert rechts).
class ParkscheinZeile {
  const ParkscheinZeile(this.beschriftung, this.wert);

  final String beschriftung;
  final String wert;
}

/// Rendert [zeilen] unter der Ueberschrift [titel] als einseitiges A6-PDF.
Future<Uint8List> parkscheinPdf({
  required String titel,
  required List<ParkscheinZeile> zeilen,
}) async {
  final dokument = pw.Document();
  dokument.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a6,
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: <pw.Widget>[
          pw.Text(
            titel,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          for (final zeile in zeilen)
            pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 6),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Expanded(child: pw.Text(zeile.beschriftung)),
                  pw.Expanded(
                    child: pw.Text(zeile.wert, textAlign: pw.TextAlign.right),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
  return dokument.save();
}
