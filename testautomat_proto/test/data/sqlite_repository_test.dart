import 'package:testautomat_proto/data/sqlite_repository.dart';

import 'repository_contract.dart';

void main() {
  runRepositoryContractTests(
    name: 'SqliteRepository',
    createRepository: () async =>
        SqliteRepository.memory(einschaltzeit: DateTime.utc(2026, 1, 1)),
  );
}
