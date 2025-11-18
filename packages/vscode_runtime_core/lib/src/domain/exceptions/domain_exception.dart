/// Base Domain Exception
/// All domain exceptions should extend this
abstract class DomainException implements Exception {
  final String message;
  final String? code;

  const DomainException(this.message, [this.code]);

  @override
  String toString() => 'DomainException($code): $message';
}

/// Invalid State Exception
/// Thrown when aggregate is in invalid state for operation
class InvalidStateException extends DomainException {
  const InvalidStateException(super.message, [super.code]);

  @override
  String toString() => 'InvalidStateException($code): $message';
}

/// Validation Exception
/// Thrown when business rule validation fails
class ValidationException extends DomainException {
  const ValidationException(super.message, [super.code]);

  @override
  String toString() => 'ValidationException($code): $message';
}

/// Installation Exception
/// Thrown when installation invariants are violated
class InstallationException extends DomainException {
  const InstallationException(super.message, [super.code]);

  @override
  String toString() => 'InstallationException($code): $message';
}

/// Verification Exception
/// Thrown when verification fails
class VerificationException extends DomainException {
  const VerificationException(super.message, [super.code]);

  @override
  String toString() => 'VerificationException($code): $message';
}

/// Not Found Exception
/// Thrown when required entity not found
class NotFoundException extends DomainException {
  const NotFoundException(super.message, [super.code]);

  @override
  String toString() => 'NotFoundException($code): $message';
}

/// Dependency Exception
/// Thrown when dependency resolution fails
class DependencyException extends DomainException {
  const DependencyException(super.message, [super.code]);

  @override
  String toString() => 'DependencyException($code): $message';
}
