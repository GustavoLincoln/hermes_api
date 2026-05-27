import '../../domain/entities/collection_entity.dart';
import '../../domain/repositories/collection_repository.dart';

class CollectionRepositoryImpl implements CollectionRepository {
  const CollectionRepositoryImpl();

  @override
  Future<List<CollectionEntity>> getCollections() async {
    return const <CollectionEntity>[];
  }
}
