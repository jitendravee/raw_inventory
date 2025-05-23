import 'package:equatable/equatable.dart';
import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';

abstract class InventoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final List<MaterialEntity> materials;

  InventoryLoaded(this.materials);

  @override
  List<Object> get props => [materials];
}

class InventoryError extends InventoryState {
  final String message;

  InventoryError(this.message);

  @override
  List<Object> get props => [message];
}
