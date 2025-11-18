import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Configure infrastructure layer dependencies
///
/// This should be called after configuring the core layer dependencies
@InjectableInit(
  initializerName: 'initInfrastructure',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureInfrastructureDependencies() async => getIt.initInfrastructure();
