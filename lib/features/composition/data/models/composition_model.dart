// data/models/composition_model.dart
import 'package:hive/hive.dart';
import '../../domain/entities/composition_entity.dart';

part 'composition_model.g.dart';

@HiveType(typeId: 1)
class CompositionModel extends HiveObject {
  @HiveField(0)
  String productName;

  @HiveField(1)
  Map<String, int> materialRequirements;

  CompositionModel({
    required this.productName,
    required this.materialRequirements,
  });

  factory CompositionModel.fromEntity(CompositionEntity entity) =>
      CompositionModel(
        productName: entity.productName,
        materialRequirements: entity.materialRequirements,
      );

  CompositionEntity toEntity() => CompositionEntity(
        productName: productName,
        materialRequirements: materialRequirements,
      );
}
