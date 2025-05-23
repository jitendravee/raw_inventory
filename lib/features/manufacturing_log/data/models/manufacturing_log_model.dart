import 'package:hive/hive.dart';
import 'package:raw_material/features/manufacturing_log/domain/entities/manufacturing_log_entity.dart';

part 'manufacturing_log_model.g.dart';

@HiveType(typeId: 3)
class ManufacturingLogModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String notes;

  ManufacturingLogModel({
    required this.date,
    required this.productName,
    required this.quantity,
    required this.notes,
  });

  factory ManufacturingLogModel.fromEntity(ManufacturingLogEntity e) =>
      ManufacturingLogModel(
        date: e.date,
        productName: e.productName,
        quantity: e.quantity,
        notes: e.notes,
      );

  ManufacturingLogEntity toEntity() => ManufacturingLogEntity(
        date: date,
        productName: productName,
        quantity: quantity,
        notes: notes,
      );
}
