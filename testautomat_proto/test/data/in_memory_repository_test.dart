import 'package:testautomat_proto/data/in_memory_repository.dart';

import 'repository_contract.dart';

void main() {
  runRepositoryContractTests(
    name: 'InMemoryRepository',
    createRepository: () async =>
        InMemoryRepository(einschaltzeit: DateTime.utc(2026, 1, 1)),
  );
}
