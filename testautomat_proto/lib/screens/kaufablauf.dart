import 'package:testautomat_proto/data/dto.dart';

/// Daten, die der Kaufablauf zwischen den Bildschirmen weitergibt.
class KaufAuswahl {
  const KaufAuswahl({
    required this.parkdauerMinuten,
    required this.betragCent,
    this.zahlungsart,
  });

  /// Gewaehlte Parkdauer in Minuten.
  final int parkdauerMinuten;

  /// Preis der gewaehlten Parkdauer in Cent (E-02, E-15).
  final int betragCent;

  /// Gewaehlte Zahlungsart; `null`, solange sie noch nicht gewaehlt wurde.
  final Zahlungsart? zahlungsart;

  /// Kopie mit gesetzter Zahlungsart.
  KaufAuswahl mitZahlungsart(Zahlungsart art) => KaufAuswahl(
    parkdauerMinuten: parkdauerMinuten,
    betragCent: betragCent,
    zahlungsart: art,
  );

  /// Liest die Auswahl aus den Routen-Argumenten.
  static KaufAuswahl aus(
    Object? argumente, {
    required int standardParkdauerMinuten,
    required int standardBetragCent,
  }) => argumente is KaufAuswahl
      ? argumente
      : KaufAuswahl(
          parkdauerMinuten: standardParkdauerMinuten,
          betragCent: standardBetragCent,
        );
}
