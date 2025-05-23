// domain/repositories/composition_repository.dart
import '../entities/composition_entity.dart';

abstract class CompositionRepository {
  Future<List<CompositionEntity>> fetchAll();
  Future<void> upsert(CompositionEntity composition);
  Future<void> delete(String productName);
  Future<CompositionEntity?> getByProduct(String productName);
}
