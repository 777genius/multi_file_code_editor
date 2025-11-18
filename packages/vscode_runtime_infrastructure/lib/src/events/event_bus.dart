import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:vscode_runtime_core/vscode_runtime_core.dart';

/// Event Bus Implementation
/// Manages domain event publishing and subscription using RxDart
class EventBus implements IEventBus {
  final _controller = PublishSubject<DomainEvent>();

  @override
  Future<void> publish(DomainEvent event) async {
    _controller.add(event);
  }

  @override
  Future<void> publishAll(List<DomainEvent> events) async {
    for (final event in events) {
      _controller.add(event);
    }
  }

  @override
  Stream<DomainEvent> get stream => _controller.stream;

  @override
  Stream<T> streamOf<T extends DomainEvent>() {
    return _controller.stream.whereType<T>();
  }

  @override
  void clear() {
    // Note: PublishSubject doesn't need explicit clearing of subscribers
    // They are automatically removed when the stream subscription is cancelled
  }

  /// Dispose of resources
  /// Should be called when the event bus is no longer needed
  void dispose() {
    _controller.close();
  }
}
