import 'package:equatable/equatable.dart';
import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';

abstract class InventoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadInventory extends InventoryEvent {}

class AddOrUpdateMaterial extends InventoryEvent {
  final MaterialEntity material;

  AddOrUpdateMaterial(this.material);

  @override
  List<Object> get props => [material];
}

class DeleteMaterial extends InventoryEvent {
  final String name;

  DeleteMaterial(this.name);

  @override
  List<Object> get props => [name];
}
