/// Fehler, den das Datenlayer nach aussen meldet (Validierung, fehlende Daten).
class RepositoryException implements Exception {
  const RepositoryException(this.message);

  final String message;

  @override
  String toString() => 'RepositoryException: $message';
}
