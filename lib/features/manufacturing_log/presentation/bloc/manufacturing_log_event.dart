import 'package:raw_material/features/manufacturing_log/domain/entities/manufacturing_log_entity.dart';

abstract class ManufacturingEvent {}

class LoadManufacturingLogs extends ManufacturingEvent {}

class AddManufacturingLog extends ManufacturingEvent {
  final ManufacturingLogEntity log;
  AddManufacturingLog(this.log);
}

class DeleteManufacturingLog extends ManufacturingEvent {
  final int index;
  DeleteManufacturingLog(this.index);
}
