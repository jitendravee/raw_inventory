import 'package:raw_material/features/manufacturing_log/data/datasources/manufacturing_log_local_datasource.dart';
import 'package:raw_material/features/manufacturing_log/data/models/manufacturing_log_model.dart';
import 'package:raw_material/features/manufacturing_log/domain/entities/manufacturing_log_entity.dart';
import 'package:raw_material/features/manufacturing_log/domain/repositories/manufacturing_log_repository.dart';

class ManufacturingRepositoryImpl implements ManufacturingRepository {
  final ManufacturingLocalDatasource local;

  ManufacturingRepositoryImpl(this.local);

  @override
  Future<List<ManufacturingLogEntity>> fetch() async {
    final models = await local.fetchAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> add(ManufacturingLogEntity log) async {
    await local.add(ManufacturingLogModel.fromEntity(log));
  }

  @override
  Future<void> delete(int index) async {
    await local.delete(index);
  }
}
