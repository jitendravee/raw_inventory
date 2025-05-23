class MaterialEntity {
  final String name;
  final int quantity;
  final int threshold;

  MaterialEntity({
    required this.name,
    required this.quantity,
    required this.threshold,
  });

  MaterialEntity copyWith({
    String? name,
    int? quantity,
    int? threshold,
  }) {
    return MaterialEntity(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      threshold: threshold ?? this.threshold,
    );
  }
}
