import 'package:flutter/material.dart';

mixin KeyCacheMixin<T> {
  UniqueKey? _uniqueKey;
  T? _cache;

  UniqueKey getUniqueKey(T arg) {
    if (arg == _cache) {
      return _uniqueKey!;
    }

    _cache = arg;
    _uniqueKey = UniqueKey();

    return _uniqueKey!;
  }
}
