import 'package:raw_material/features/manufacturing_log/domain/entities/manufacturing_log_entity.dart';

abstract class ManufacturingState {}

class ManufacturingLoading extends ManufacturingState {}

class ManufacturingLoaded extends ManufacturingState {
  final List<ManufacturingLogEntity> logs;
  ManufacturingLoaded(this.logs);
}

class ManufacturingError extends ManufacturingState {
  final String message;
  ManufacturingError(this.message);
}

class AddManufacturingDoesNotExistError extends ManufacturingState {
  final String message;
  AddManufacturingDoesNotExistError({required this.message});
}

class AddManufacturingDoesNotExistInInventoryError extends ManufacturingState {
  final String message;
  AddManufacturingDoesNotExistInInventoryError({required this.message});
}
