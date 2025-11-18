import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

/// Configure presentation layer dependencies
///
/// This should be called after configuring the application layer dependencies
@InjectableInit(
  initializerName: 'initPresentation',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configurePresentationDependencies() async => getIt.initPresentation();
