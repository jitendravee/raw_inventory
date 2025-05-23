import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raw_material/features/composition/domain/repositories/composition_repository.dart';
import 'package:raw_material/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:raw_material/features/manufacturing_log/domain/repositories/manufacturing_log_repository.dart';
import 'package:raw_material/features/manufacturing_log/presentation/bloc/manufacturing_log_event.dart';
import 'package:raw_material/features/manufacturing_log/presentation/bloc/manufacturing_log_state.dart';

class ManufacturingBloc extends Bloc<ManufacturingEvent, ManufacturingState> {
  final ManufacturingRepository repo;
  final CompositionRepository compositionRepo;
  final InventoryRepository inventoryRepo;

  ManufacturingBloc(this.repo, this.compositionRepo, this.inventoryRepo)
      : super(ManufacturingLoading()) {
    on<LoadManufacturingLogs>((event, emit) async {
      emit(ManufacturingLoading());
      try {
        final logs = await repo.fetch();
        emit(ManufacturingLoaded(logs));
      } catch (e) {
        emit(ManufacturingError(e.toString()));
      }
    });

    // on<AddManufacturingLog>((event, emit) async {
    //   await repo.add(event.log);
    //   add(LoadManufacturingLogs());
    // });

    on<DeleteManufacturingLog>((event, emit) async {
      await repo.delete(event.index);
      add(LoadManufacturingLogs());
    });
    on<AddManufacturingLog>((event, emit) async {
      try {
        final composition =
            await compositionRepo.getByProduct(event.log.productName);
        if (composition == null) {
          emit(AddManufacturingDoesNotExistError(
              message: event.log.productName));
          return;
        }

        for (final entry in composition.materialRequirements.entries) {
          final name = entry.key;
          final requiredQty = entry.value * event.log.quantity;

          final material = await inventoryRepo.getByName(name);
          if (material == null) {
            emit(AddManufacturingDoesNotExistInInventoryError(message: name));
            return;
          }

          final updatedQty = material.quantity - requiredQty;
          if (updatedQty < 0) {
            emit(ManufacturingError(
                'Not enough $name. Needed: $requiredQty, Available: ${material.quantity}'));
            return;
          }

          final updatedMaterial = material.copyWith(quantity: updatedQty);
          await inventoryRepo.upsert(updatedMaterial);
        }

        await repo.add(event.log);
        add(LoadManufacturingLogs());
      } catch (e) {
        emit(ManufacturingError('Failed to add log: $e'));
      }
    });
  }
}
