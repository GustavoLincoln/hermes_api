import '../entities/collection_entity.dart';
import '../repositories/collection_repository.dart';

class GetCollectionsUsecase {
  const GetCollectionsUsecase(this._repository);

  final CollectionRepository _repository;

  Future<List<CollectionEntity>> call() {
    return _repository.getCollections();
  }
}
