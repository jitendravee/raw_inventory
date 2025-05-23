import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:raw_material/features/inventory/presentation/widgets/inventory_textfield.dart';
import 'package:raw_material/features/manufacturing_log/domain/entities/manufacturing_log_entity.dart';
import 'package:raw_material/features/manufacturing_log/presentation/bloc/manufacturing_log_bloc.dart';
import 'package:raw_material/features/manufacturing_log/presentation/bloc/manufacturing_log_event.dart';
import 'package:raw_material/features/manufacturing_log/presentation/bloc/manufacturing_log_state.dart';

class ManufacturingScreen extends StatefulWidget {
  const ManufacturingScreen({super.key});

  @override
  State<ManufacturingScreen> createState() => _ManufacturingScreenState();
}

class _ManufacturingScreenState extends State<ManufacturingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ManufacturingBloc>().add(LoadManufacturingLogs());
  }

  void _showAddLogDialog(BuildContext context) {
    final productController = TextEditingController();
    final quantityController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('New Manufacturing Log'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InventoryTextField(
                controller: productController,
                label: 'Product Name',
              ),
              InventoryTextField(
                controller: quantityController,
                label: 'Quantity',
                keyboardType: TextInputType.number,
              ),
              InventoryTextField(
                controller: notesController,
                label: 'Notes',
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
              final productName = productController.text.trim();
              final quantity =
                  int.tryParse(quantityController.text.trim()) ?? 0;
              final notes = notesController.text.trim();

              if (productName.isNotEmpty && quantity > 0) {
                final log = ManufacturingLogEntity(
                  date: DateTime.now(),
                  productName: productName,
                  quantity: quantity,
                  notes: notes,
                );
                context.read<ManufacturingBloc>().add(AddManufacturingLog(log));
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manufacturing Log'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<ManufacturingBloc, ManufacturingState>(
          listener: (context, state) {
            if (state is AddManufacturingDoesNotExistError) {
              _showErrorDialog(context,
                  'Product "${state.message}" does not exist in composition data.');
              context.read<ManufacturingBloc>().add(LoadManufacturingLogs());
            } else if (state is AddManufacturingDoesNotExistInInventoryError) {
              _showErrorDialog(context,
                  'Material "${state.message}" not found in inventory.');
              context.read<ManufacturingBloc>().add(LoadManufacturingLogs());
            } else if (state is ManufacturingError) {
              _showErrorDialog(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is ManufacturingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ManufacturingLoaded) {
              if (state.logs.isEmpty) {
                return const Center(child: Text('No logs yet.'));
              }

              return ListView.separated(
                itemCount: state.logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final log = state.logs[i];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        '${log.productName} - ${log.quantity} units',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${DateFormat('d MMM yy HH:mm').format(log.date)}\n${log.notes}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            }

            return const Center(child: Text('Error loading logs'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddLogDialog(context),
        label: const Text(
          "Add Log",
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
