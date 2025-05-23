// presentation/bloc/composition_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/composition_repository.dart';
import 'composition_event.dart';
import 'composition_state.dart';

class CompositionBloc extends Bloc<CompositionEvent, CompositionState> {
  final CompositionRepository repository;

  CompositionBloc(this.repository) : super(CompositionLoading()) {
    on<LoadCompositions>((event, emit) async {
      emit(CompositionLoading());
      try {
        final data = await repository.fetchAll();
        emit(CompositionLoaded(data));
      } catch (e) {
        emit(CompositionError(e.toString()));
      }
    });

    on<AddOrUpdateComposition>((event, emit) async {
      await repository.upsert(event.composition);
      add(LoadCompositions());
    });

    on<DeleteComposition>((event, emit) async {
      await repository.delete(event.productName);
      add(LoadCompositions());
    });
  }
}
