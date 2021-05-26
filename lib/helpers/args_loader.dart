import 'package:flutter/material.dart';

mixin ArgsLoader<T, E> {
  T? _cache;

  Future<T?> loadArguments(E id);

  E getId();

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

    var result = await loadArguments(getId());
    _cache = result;
    return _cache;
  }

  T? get cache => _cache;
}
