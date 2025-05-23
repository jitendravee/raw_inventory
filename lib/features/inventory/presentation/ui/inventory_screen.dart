import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raw_material/core/common/success_pop_up.dart';
import 'package:raw_material/features/inventory/domain/entities/inventory_entity.dart';
import 'package:raw_material/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:raw_material/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:raw_material/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:raw_material/features/inventory/presentation/widgets/inventory_textfield.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Add the missing method here:
  @override
  void initState() {
    super.initState();
    context.read<InventoryBloc>().add(LoadInventory());
  }

  void _showEditDialog(BuildContext context, MaterialEntity? material) {
    final nameController = TextEditingController(text: material?.name ?? '');
    final quantityController =
        TextEditingController(text: material?.quantity.toString() ?? '');
    final thresholdController =
        TextEditingController(text: material?.threshold.toString() ?? '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            material == null ? 'Add Material' : 'Edit Material',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InventoryTextField(
                  controller: nameController,
                  label: 'Name',
                ),
                InventoryTextField(
                  controller: quantityController,
                  label: 'Quantity',
                  keyboardType: TextInputType.number,
                ),
                InventoryTextField(
                  controller: thresholdController,
                  label: 'Threshold',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final quantity = int.tryParse(quantityController.text) ??
                    material?.quantity ??
                    0;
                final threshold = int.tryParse(thresholdController.text) ??
                    material?.threshold ??
                    0;

                if (name.isNotEmpty) {
                  final newMaterial = MaterialEntity(
                    name: name,
                    quantity: quantity,
                    threshold: threshold,
                  );
                  context
                      .read<InventoryBloc>()
                      .add(AddOrUpdateMaterial(newMaterial));
                  Navigator.pop(context);
                  showSuccessPopup(context, message: "Inventory Updated!");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                material == null ? 'Add' : 'Update',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, state) {
            if (state is InventoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is InventoryLoaded) {
              return ListView.separated(
                itemCount: state.materials.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final m = state.materials[i];
                  final progress =
                      (m.quantity / (m.threshold == 0 ? 1 : m.threshold))
                          .clamp(0.0, 1.0);
                  final isBelowThreshold = m.quantity < m.threshold;

                  return GestureDetector(
                    onTap: () {
                      _showEditDialog(context, m);
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    m.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Icon(
                                  isBelowThreshold
                                      ? Icons.warning
                                      : Icons.check_circle,
                                  color: isBelowThreshold
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(16),
                              value: progress,
                              backgroundColor: Colors.grey.shade300,
                              color:
                                  isBelowThreshold ? Colors.red : Colors.green,
                              minHeight: 8,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Quantity: ${m.quantity}'),
                                Text('Threshold: ${m.threshold}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(context, null),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          "Add Material",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
