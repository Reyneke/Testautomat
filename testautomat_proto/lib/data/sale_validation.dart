import 'dto.dart';
import 'repository_exception.dart';
import '../logic/kennzeichen.dart';

/// Prueft einen Verkaufsentwurf vor dem Schreiben (`2_Datenbank.md`, E-16).
///
/// Wirft eine [RepositoryException], wenn der Entwurf die Regeln der Tabelle
/// `verkaeufe` verletzen wuerde (CHECK-Constraints).
VerkaufDraft validateVerkaufDraft(VerkaufDraft draft) {
  if (draft.maschineId <= 0) {
    throw const RepositoryException('maschine_id muss groesser als 0 sein.');
  }
  if (draft.parkdauerMinuten <= 0) {
    throw const RepositoryException(
      'parkdauer_minuten muss groesser als 0 sein.',
    );
  }
  if (draft.betragCent < 0) {
    throw const RepositoryException('betrag_cent darf nicht negativ sein.');
  }
  final kennzeichen = draft.kennzeichen;
  if (kennzeichen != null && !istGueltigesKennzeichen(kennzeichen)) {
    throw RepositoryException('Ungueltiges Kennzeichen: $kennzeichen');
  }
  return draft;
}
