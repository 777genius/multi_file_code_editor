/// Base Specification Pattern
/// Encapsulates business rules as objects
abstract class Specification<T> {
  bool isSatisfiedBy(T candidate);

  String get description;

  /// AND operation
  Specification<T> and(Specification<T> other) {
    return AndSpecification(this, other);
  }

  /// OR operation
  Specification<T> or(Specification<T> other) {
    return OrSpecification(this, other);
  }

  /// NOT operation
  Specification<T> not() {
    return NotSpecification(this);
  }
}

/// AND Specification
class AndSpecification<T> extends Specification<T> {
  final Specification<T> left;
  final Specification<T> right;

  AndSpecification(this.left, this.right);

  @override
  bool isSatisfiedBy(T candidate) {
    return left.isSatisfiedBy(candidate) && right.isSatisfiedBy(candidate);
  }

  @override
  String get description => '(${left.description} AND ${right.description})';
}

/// OR Specification
class OrSpecification<T> extends Specification<T> {
  final Specification<T> left;
  final Specification<T> right;

  OrSpecification(this.left, this.right);

  @override
  bool isSatisfiedBy(T candidate) {
    return left.isSatisfiedBy(candidate) || right.isSatisfiedBy(candidate);
  }

  @override
  String get description => '(${left.description} OR ${right.description})';
}

/// NOT Specification
class NotSpecification<T> extends Specification<T> {
  final Specification<T> spec;

  NotSpecification(this.spec);

  @override
  bool isSatisfiedBy(T candidate) {
    return !spec.isSatisfiedBy(candidate);
  }

  @override
  String get description => 'NOT ${spec.description}';
}

/// Composite Specification (AND all)
class CompositeSpecification<T> extends Specification<T> {
  final List<Specification<T>> specifications;

  CompositeSpecification(this.specifications);

  @override
  bool isSatisfiedBy(T candidate) {
    return specifications.every((spec) => spec.isSatisfiedBy(candidate));
  }

  @override
  String get description {
    final descriptions = specifications.map((s) => s.description).join(' AND ');
    return '($descriptions)';
  }
}
