import 'package:hive/hive.dart';
import 'package:raw_material/features/manufacturing_log/data/models/manufacturing_log_model.dart';

class ManufacturingLocalDatasource {
  final Box<ManufacturingLogModel> box;

  ManufacturingLocalDatasource(this.box);

  Future<List<ManufacturingLogModel>> fetchAll() async {
    return box.values.toList();
  }

  Future<void> add(ManufacturingLogModel log) async {
    await box.add(log);
  }

  Future<void> delete(int index) async {
    await box.deleteAt(index);
  }
}
