import '../entities/runtime_module.dart';
import '../value_objects/platform_identifier.dart';
import 'specification.dart';

/// Specification: Platform Compatibility
/// Business rule: Module must support target platform
class PlatformCompatibleSpecification extends Specification<RuntimeModule> {
  final PlatformIdentifier platform;

  PlatformCompatibleSpecification(this.platform);

  @override
  bool isSatisfiedBy(RuntimeModule candidate) {
    return candidate.isAvailableForPlatform(platform);
  }

  @override
  String get description => 'Module must support platform: ${platform.identifier}';
}
