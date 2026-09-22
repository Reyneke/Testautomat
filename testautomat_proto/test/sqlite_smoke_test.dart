import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('sqlite3 laesst sich im Testkontext laden', () {
    final db = sqlite3.openInMemory();
    final version =
        db.select('SELECT sqlite_version() AS v').first['v'] as String;
    expect(version, isNotEmpty);
    db.close();
  });
}
