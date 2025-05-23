import 'package:raw_material/features/manufacturing_log/domain/entities/manufacturing_log_entity.dart';

abstract class ManufacturingRepository {
  Future<List<ManufacturingLogEntity>> fetch();
  Future<void> add(ManufacturingLogEntity log);
  Future<void> delete(int index);
}
