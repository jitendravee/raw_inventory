// presentation/screens/composition_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raw_material/features/inventory/presentation/widgets/inventory_textfield.dart';
import '../../domain/entities/composition_entity.dart';
import '../bloc/composition_bloc.dart';
import '../bloc/composition_event.dart';
import '../bloc/composition_state.dart';

class CompositionScreen extends StatefulWidget {
  const CompositionScreen({super.key});

  @override
  State<CompositionScreen> createState() => _CompositionScreenState();
}

class _CompositionScreenState extends State<CompositionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompositionBloc>().add(LoadCompositions());
  }

  void _showEditDialog(BuildContext context, [CompositionEntity? comp]) {
    final productController =
        TextEditingController(text: comp?.productName ?? '');
    final materialsController = TextEditingController(
      text: comp?.materialRequirements.entries
              .map((e) => '${e.key}:${e.value}')
              .join(', ') ??
          '',
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          comp == null ? 'Add Composition' : 'Edit Composition',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InventoryTextField(
                controller: productController,
                label: 'Product Name',
              ),
              InventoryTextField(
                controller: materialsController,
                label: 'Materials (e.g. iron:2, steel:3)',
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
              final materials = <String, int>{};
              for (var entry in materialsController.text.split(',')) {
                final parts = entry.split(':');
                if (parts.length == 2) {
                  materials[parts[0].trim()] =
                      int.tryParse(parts[1].trim()) ?? 0;
                }
              }

              final newComp = CompositionEntity(
                productName: productController.text.trim(),
                materialRequirements: materials,
              );

              context
                  .read<CompositionBloc>()
                  .add(AddOrUpdateComposition(newComp));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compositions'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocBuilder<CompositionBloc, CompositionState>(
          builder: (context, state) {
            if (state is CompositionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CompositionLoaded) {
              return ListView.separated(
                itemCount: state.compositions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final comp = state.compositions[i];
                  final materials = comp.materialRequirements.entries
                      .map((e) => '${e.key}: ${e.value}')
                      .join(', ');

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        comp.productName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(materials),
                      onTap: () => _showEditDialog(context, comp),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => context
                            .read<CompositionBloc>()
                            .add(DeleteComposition(comp.productName)),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(child: Text("Failed to load data"));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEditDialog(context),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: const Text(
          "Add",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
