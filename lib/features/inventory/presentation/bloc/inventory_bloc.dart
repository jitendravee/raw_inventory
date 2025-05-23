import 'package:flutter_bloc/flutter_bloc.dart';
import 'inventory_event.dart';
import 'inventory_state.dart';
import '../../domain/repositories/inventory_repository.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final InventoryRepository repo;

  InventoryBloc(this.repo) : super(InventoryLoading()) {
    on<LoadInventory>((event, emit) async {
      emit(InventoryLoading());
      try {
        final items = await repo.fetch();
        emit(InventoryLoaded(items));
      } catch (e) {
        emit(InventoryError(e.toString()));
      }
    });

    on<AddOrUpdateMaterial>((event, emit) async {
      await repo.upsert(event.material);
      add(LoadInventory());
    });

    on<DeleteMaterial>((event, emit) async {
      await repo.delete(event.name);
      add(LoadInventory());
    });
  }
}
