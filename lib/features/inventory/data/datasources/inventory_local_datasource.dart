import 'package:hive/hive.dart';
import 'package:raw_material/features/inventory/data/models/inventory_model.dart';
import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';

class HiveInventoryDatasource {
  final Box<MaterialModel> _box = Hive.box<MaterialModel>('materials');

  Future<List<MaterialEntity>> getAll() async {
    return _box.values.map((m) => m.toEntity()).toList();
  }

  Future<void> upsert(MaterialEntity material) async {
    await _box.put(material.name, MaterialModel.fromEntity(material));
  }

  Future<void> delete(String name) async {
    await _box.delete(name);
  }

  Future<MaterialEntity?> getByName(String name) async {
    final model = _box.get(name);
    return model?.toEntity(); // ✅ returns null if not found
  }
}
