import 'package:flutter/material.dart';
import 'package:rapidoc_utils/alerts/alert_vertical_widget.dart';
import 'package:rapidoc_utils/lang/lang.dart';
import 'package:rxdart/rxdart.dart';

class ArgsLoaderWidget<T> extends StatefulWidget {
  final Future<T?> Function() loader;
  final Function(BuildContext context, T args) builder;
  final Function(BuildContext context, dynamic error)? errorBuilder;
  final Function(BuildContext context)? progressBuilder;
  final Function(BuildContext context)? notFoundBuilder;

  final bool ignoreModalRouteArgument;
  final T? initialData;

  ArgsLoaderWidget({
    Key? key,
    required this.loader,
    required this.builder,
    this.errorBuilder,
    this.progressBuilder,
    this.notFoundBuilder,
    required this.ignoreModalRouteArgument,
    this.initialData,
  }) : super(key: key);

  @override
  ArgsLoaderWidgetState<T> createState() => ArgsLoaderWidgetState<T>();
}

class ArgsLoaderWidgetState<T> extends State<ArgsLoaderWidget<T>> {
  var lang = appLocalizationsWrapper.lang;

  final _subject = BehaviorSubject<_Data<T>>();
  final _loadingSubject = BehaviorSubject.seeded(false);
  bool _firstTime = true;

  Future<void> _loadData(BuildContext context, [bool? forceRefresh]) async {
    if (!(forceRefresh ?? false) && !widget.ignoreModalRouteArgument) {
      var args = ModalRoute.of(context)?.settings.arguments as T?;
      if (args != null) {
        _subject.add(
          _Data(
            data: args,
            error: null,
          ),
        );
        return;
      }
    }

    if (widget.initialData != null) {
      _subject.add(
        _Data(
          data: widget.initialData!,
          error: null,
        ),
      );
      return;
    }

    await _doLoadData();
  }

  Future<void> _doLoadData() async {
    try {
      _loadingSubject.add(true);
      var result = await widget.loader();
      _subject.add(
        _Data(
          data: result,
          error: null,
        ),
      );
    } catch (error) {
      _subject.add(
        _Data(
          data: null,
          error: error,
        ),
      );
    } finally {
      _loadingSubject.add(false);
    }
  }

  @override
  void dispose() {
    _subject.close();
    _loadingSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      _loadData(context, false);
      _firstTime = false;
    }
    return StreamBuilder<_Data<T>>(
      stream: Rx.combineLatest([_subject, _loadingSubject], (values) {
        var _data = values[0] as _Data<T>;
        var loading = values[1] as bool;
        return _Data(data: _data.data, error: _data.error, loading: loading);
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          if (widget.progressBuilder != null) {
            return widget.progressBuilder!(context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }

        var _data = snapshot.data!;

        if (_data.error != null) {
          var _errorBuilder = widget.errorBuilder;

          if (_errorBuilder != null) {
            return _wrapInRefreshIndicator(
              context,
              (context) => _errorBuilder(context, _data.error),
            );
          } else {
            return _wrapInRefreshIndicator(
              context,
              (context) => Center(
                child: Column(
                  children: [
                    AlertVerticalWidget.createDanger(lang.couldNotLoadData),
                    IconButton(
                      onPressed: () => _loadData(context, true),
                      icon: Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          var data = _data.data;
          if (data == null) {
            if (widget.notFoundBuilder != null) {
              return _wrapInRefreshIndicator(
                  context, (context) => widget.notFoundBuilder!(context));
            } else {
              return _wrapInRefreshIndicator(
                context,
                (context) => AlertVerticalWidget.createDanger(
                  lang.dataNotFound,
                ),
              );
            }
          } else {
            return _wrapInRefreshIndicator(
              context,
              (context) => widget.builder(context, data),
            );
          }
        }
      },
    );
  }

  Widget _wrapInRefreshIndicator(
    BuildContext context,
    Widget Function(BuildContext context) childBuilder,
  ) {
    return RefreshIndicator(
      onRefresh: () => _loadData(context, true),
      child: childBuilder(context),
    );
  }

  Future<void> reload() {
    return _doLoadData();
  }

  void updateCache(T? data) {
    _subject.add(_Data(data: data, error: null));
  }

  T? get currentValue => _subject.valueOrNull?.data;
}

class _Data<T> {
  final T? data;
  final dynamic error;
  final bool loading;

  _Data({
    required this.data,
    required this.error,
    this.loading: false,
  });
}
