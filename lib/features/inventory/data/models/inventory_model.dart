import 'package:hive/hive.dart';
import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';
part 'inventory_model.g.dart';

@HiveType(typeId: 0)
class MaterialModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int quantity;

  @HiveField(2)
  final int threshold;

  MaterialModel({
    required this.name,
    required this.quantity,
    required this.threshold,
  });

  // Convert from domain entity to model
  factory MaterialModel.fromEntity(MaterialEntity entity) => MaterialModel(
        name: entity.name,
        quantity: entity.quantity,
        threshold: entity.threshold,
      );

  // Convert to domain entity
  MaterialEntity toEntity() => MaterialEntity(
        name: name,
        quantity: quantity,
        threshold: threshold,
      );
}
