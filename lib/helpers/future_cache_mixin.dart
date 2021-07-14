mixin FutureCacheMixin<T> {
  T? _cache;

  Future<T> load() async {
    if (_cache == null) {
      var r = await getFuture().call();
      _cache = r;
    }
    return Future.value(_cache);
  }

  Future<T> Function() getFuture();

  void setCache(T cache) {
    this._cache = cache;
  }
}
