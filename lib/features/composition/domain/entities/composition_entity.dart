// domain/entities/composition_entity.dart
class CompositionEntity {
  final String productName;
  final Map<String, int> materialRequirements; // materialName: quantity

  CompositionEntity({
    required this.productName,
    required this.materialRequirements,
  });
}
