import 'package:testautomat_proto/data/dto.dart';

/// Daten, die der Kaufablauf zwischen den Bildschirmen weitergibt.
///
/// Phase 2 traegt nur die gewaehlte Parkdauer und die Zahlungsart; Betraege und
/// Belegnummern folgen mit U-31 und U-33.
class KaufAuswahl {
  const KaufAuswahl({required this.parkdauerMinuten, this.zahlungsart});

  /// Gewaehlte Parkdauer in Minuten.
  final int parkdauerMinuten;

  /// Gewaehlte Zahlungsart; `null`, solange sie noch nicht gewaehlt wurde.
  final Zahlungsart? zahlungsart;

  /// Kopie mit gesetzter Zahlungsart.
  KaufAuswahl mitZahlungsart(Zahlungsart art) =>
      KaufAuswahl(parkdauerMinuten: parkdauerMinuten, zahlungsart: art);

  /// Liest die Auswahl aus den Routen-Argumenten.
  ///
  /// Fehlt ein Argument (direkter Aufruf im Test), gilt [standardParkdauerMinuten].
  static KaufAuswahl aus(
    Object? argumente, {
    required int standardParkdauerMinuten,
  }) => argumente is KaufAuswahl
      ? argumente
      : KaufAuswahl(parkdauerMinuten: standardParkdauerMinuten);
}
