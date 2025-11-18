import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Configure application layer dependencies
///
/// This should be called after configuring the infrastructure layer dependencies
@InjectableInit(
  initializerName: 'initApplication',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureApplicationDependencies() async => getIt.initApplication();
