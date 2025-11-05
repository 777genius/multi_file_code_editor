import 'dart:async';

typedef HookCallback<T> = FutureOr<void> Function(T data);

class Hook<T> {
  final String name;
  final List<HookCallback<T>> _callbacks = [];

  Hook(this.name);

  void register(HookCallback<T> callback) {
    _callbacks.add(callback);
  }

  void unregister(HookCallback<T> callback) {
    _callbacks.remove(callback);
  }

  Future<void> execute(T data) async {
    for (final callback in _callbacks) {
      try {
        await callback(data);
      } catch (e) {
        // Hook execution error - silently continue
        // In production, consider using a proper logging framework
      }
    }
  }

  int get callbackCount => _callbacks.length;

  void clear() {
    _callbacks.clear();
  }
}

class HookRegistry {
  final Map<String, Hook<dynamic>> _hooks = {};

  Hook<T> getOrCreate<T>(String hookName) {
    if (_hooks.containsKey(hookName)) {
      return _hooks[hookName]! as Hook<T>;
    }
    final hook = Hook<T>(hookName);
    _hooks[hookName] = hook;
    return hook;
  }

  Hook<T>? get<T>(String hookName) {
    return _hooks[hookName] as Hook<T>?;
  }

  void register<T>(String hookName, HookCallback<T> callback) {
    final hook = getOrCreate<T>(hookName);
    hook.register(callback);
  }

  void unregister<T>(String hookName, HookCallback<T> callback) {
    final hook = get<T>(hookName);
    hook?.unregister(callback);
  }

  Future<void> execute<T>(String hookName, T data) async {
    final hook = get<T>(hookName);
    if (hook != null) {
      await hook.execute(data);
    }
  }

  List<String> get allHookNames => _hooks.keys.toList();

  void clear() {
    for (final hook in _hooks.values) {
      hook.clear();
    }
    _hooks.clear();
  }
}
