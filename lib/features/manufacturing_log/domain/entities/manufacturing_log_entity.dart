class ManufacturingLogEntity {
  final DateTime date;
  final String productName;
  final int quantity;
  final String notes;

  ManufacturingLogEntity({
    required this.date,
    required this.productName,
    required this.quantity,
    required this.notes,
  });
}
