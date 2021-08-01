import 'package:flutter/material.dart';

mixin ArgsLoader<T> {
  T? _cache;

  Future<T?> loadArguments();

  void initCache(T? value) {
    _cache = value;
  }

  Future<T?> getArgs(BuildContext context) async {
    if (_cache != null) {
      return _cache;
    }

    var args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      _cache = args as T;
      return _cache;
    }

    var result = await loadArguments();
    _cache = result;
    return _cache;
  }

  T? get cache => _cache;
}
