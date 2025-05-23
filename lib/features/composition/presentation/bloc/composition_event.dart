// presentation/bloc/composition_event.dart
import '../../domain/entities/composition_entity.dart';

abstract class CompositionEvent {}

class LoadCompositions extends CompositionEvent {}

class AddOrUpdateComposition extends CompositionEvent {
  final CompositionEntity composition;
  AddOrUpdateComposition(this.composition);
}

class DeleteComposition extends CompositionEvent {
  final String productName;
  DeleteComposition(this.productName);
}
