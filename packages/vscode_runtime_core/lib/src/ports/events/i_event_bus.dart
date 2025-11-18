import '../../domain/events/domain_event.dart';

/// Port: Event Bus
/// Interface for publishing and subscribing to domain events
abstract class IEventBus {
  /// Publish domain event
  Future<void> publish(DomainEvent event);

  /// Publish multiple events
  Future<void> publishAll(List<DomainEvent> events);

  /// Subscribe to all events
  Stream<DomainEvent> get stream;

  /// Subscribe to specific event type
  Stream<T> streamOf<T extends DomainEvent>();

  /// Clear all subscribers (for testing)
  void clear();
}
