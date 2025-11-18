import 'package:freezed_annotation/freezed_annotation.dart';
import '../value_objects/installation_id.dart';
import '../value_objects/module_id.dart';
import '../enums/installation_status.dart';

part 'domain_event.freezed.dart';

/// Base Domain Event
/// All domain events extend from this
abstract class DomainEvent {
  DateTime get timestamp;
  String get eventType;

  const DomainEvent();
}

/// Installation Started Event
@freezed
class InstallationStarted extends DomainEvent with _$InstallationStarted {
  const InstallationStarted._();

  const factory InstallationStarted({
    required InstallationId installationId,
    required int moduleCount,
    required DateTime timestamp,
  }) = _InstallationStarted;

  @override
  String get eventType => 'InstallationStarted';
}

/// Installation Progress Changed Event
@freezed
class InstallationProgressChanged extends DomainEvent
    with _$InstallationProgressChanged {
  const InstallationProgressChanged._();

  const factory InstallationProgressChanged({
    required InstallationId installationId,
    required InstallationStatus status,
    required DateTime timestamp,
    double? progress,
  }) = _InstallationProgressChanged;

  @override
  String get eventType => 'InstallationProgressChanged';
}

/// Module Download Started Event
@freezed
class ModuleDownloadStarted extends DomainEvent with _$ModuleDownloadStarted {
  const ModuleDownloadStarted._();

  const factory ModuleDownloadStarted({
    required InstallationId installationId,
    required ModuleId moduleId,
    required DateTime timestamp,
  }) = _ModuleDownloadStarted;

  @override
  String get eventType => 'ModuleDownloadStarted';
}

/// Module Downloaded Event
@freezed
class ModuleDownloaded extends DomainEvent with _$ModuleDownloaded {
  const ModuleDownloaded._();

  const factory ModuleDownloaded({
    required InstallationId installationId,
    required ModuleId moduleId,
    required DateTime timestamp,
  }) = _ModuleDownloaded;

  @override
  String get eventType => 'ModuleDownloaded';
}

/// Module Verified Event
@freezed
class ModuleVerified extends DomainEvent with _$ModuleVerified {
  const ModuleVerified._();

  const factory ModuleVerified({
    required InstallationId installationId,
    required ModuleId moduleId,
    required DateTime timestamp,
  }) = _ModuleVerified;

  @override
  String get eventType => 'ModuleVerified';
}

/// Module Extraction Started Event
@freezed
class ModuleExtractionStarted extends DomainEvent
    with _$ModuleExtractionStarted {
  const ModuleExtractionStarted._();

  const factory ModuleExtractionStarted({
    required InstallationId installationId,
    required ModuleId moduleId,
    required DateTime timestamp,
  }) = _ModuleExtractionStarted;

  @override
  String get eventType => 'ModuleExtractionStarted';
}

/// Module Extracted Event
@freezed
class ModuleExtracted extends DomainEvent with _$ModuleExtracted {
  const ModuleExtracted._();

  const factory ModuleExtracted({
    required InstallationId installationId,
    required ModuleId moduleId,
    required DateTime timestamp,
  }) = _ModuleExtracted;

  @override
  String get eventType => 'ModuleExtracted';
}

/// Installation Completed Event
@freezed
class InstallationCompleted extends DomainEvent with _$InstallationCompleted {
  const InstallationCompleted._();

  const factory InstallationCompleted({
    required InstallationId installationId,
    required DateTime timestamp,
  }) = _InstallationCompleted;

  @override
  String get eventType => 'InstallationCompleted';
}

/// Installation Failed Event
@freezed
class InstallationFailed extends DomainEvent with _$InstallationFailed {
  const InstallationFailed._();

  const factory InstallationFailed({
    required InstallationId installationId,
    required String error,
    required DateTime timestamp,
    String? failedModuleId,
  }) = _InstallationFailed;

  @override
  String get eventType => 'InstallationFailed';
}

/// Installation Cancelled Event
@freezed
class InstallationCancelled extends DomainEvent with _$InstallationCancelled {
  const InstallationCancelled._();

  const factory InstallationCancelled({
    required InstallationId installationId,
    required DateTime timestamp,
    String? reason,
  }) = _InstallationCancelled;

  @override
  String get eventType => 'InstallationCancelled';
}
