import 'package:flutter/widgets.dart';
import 'package:flutter_monaco/flutter_monaco.dart';

/// A tiny, no-UI helper that reasserts Monaco focus on common desktop events.
///
/// - Calls [MonacoController.ensureEditorFocus] when the app is resumed.
/// - Optionally subscribes to the current [PageRoute] via a [RouteObserver]
///   and re-focuses when the route becomes visible again (didPopNext).
///
/// This is an optional utility for desktop apps that frequently switch routes
/// or windows. Place it near your editor once you have the controller.
class MonacoFocusGuard extends StatefulWidget {
  const MonacoFocusGuard({
    super.key,
    required this.controller,
    this.routeObserver,
    this.ensureAttempts = 3,
  });

  final MonacoController controller;
  final RouteObserver<PageRoute<dynamic>>? routeObserver;
  final int ensureAttempts;

  @override
  State<MonacoFocusGuard> createState() => _MonacoFocusGuardState();
}

class _MonacoFocusGuardState extends State<MonacoFocusGuard>
    with WidgetsBindingObserver, RouteAware {
  PageRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.routeObserver != null) {
      final route = ModalRoute.of(context);
      if (route is PageRoute<dynamic>) {
        _route = route;
        widget.routeObserver!.subscribe(this, route);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.routeObserver != null && _route != null) {
      widget.routeObserver!.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.controller.ensureEditorFocus(attempts: widget.ensureAttempts);
    }
  }

  @override
  void didPopNext() {
    widget.controller.ensureEditorFocus(attempts: widget.ensureAttempts);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
