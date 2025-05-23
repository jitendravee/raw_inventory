// data/repositories/composition_repository_impl.dart
import 'package:hive/hive.dart';
import '../../domain/entities/composition_entity.dart';
import '../../domain/repositories/composition_repository.dart';
import '../models/composition_model.dart';

class CompositionRepositoryImpl implements CompositionRepository {
  final Box<CompositionModel> box;

  CompositionRepositoryImpl(this.box);

  @override
  Future<List<CompositionEntity>> fetchAll() async =>
      box.values.map((e) => e.toEntity()).toList();

  @override
  Future<void> upsert(CompositionEntity composition) async {
    await box.put(
        composition.productName, CompositionModel.fromEntity(composition));
  }

  @override
  Future<void> delete(String productName) async {
    await box.delete(productName);
  }

  @override
  Future<CompositionEntity?> getByProduct(String productName) async {
    final model = box.get(productName);
    return model?.toEntity();
  }
}
