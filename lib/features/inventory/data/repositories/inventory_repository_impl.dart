import 'package:raw_material/features/inventory/data/datasources/inventory_local_datasource.dart';
import 'package:raw_material/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';

import '../../domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final HiveInventoryDatasource local;
  final SheetsInventoryDatasource remote;

  InventoryRepositoryImpl(this.local, this.remote);

  @override
  Future<List<MaterialEntity>> fetch() async {
    try {
      final cloud = await remote.getAll();
      for (final m in cloud) {
        await local.upsert(m);
      }
      return cloud;
    } catch (_) {
      return local.getAll();
    }
  }

  @override
  Future<void> upsert(MaterialEntity m) async {
    await local.upsert(m);
    remote.upsert(m).ignore();
  }

  @override
  Future<void> delete(String name) async {
    await local.delete(name);
  }

  @override
  Future<MaterialEntity?> getByName(String name) async {
    return local.getByName(name);
  }
}
