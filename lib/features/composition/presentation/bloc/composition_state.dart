// presentation/bloc/composition_state.dart
import '../../domain/entities/composition_entity.dart';

abstract class CompositionState {}

class CompositionLoading extends CompositionState {}

class CompositionLoaded extends CompositionState {
  final List<CompositionEntity> compositions;
  CompositionLoaded(this.compositions);
}

class CompositionError extends CompositionState {
  final String message;
  CompositionError(this.message);
}
