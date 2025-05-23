import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';

abstract class InventoryRepository {
  Future<List<MaterialEntity>> fetch();
  Future<void> upsert(MaterialEntity material);
  Future<void> delete(String name);
  Future<MaterialEntity?> getByName(String name);
}
