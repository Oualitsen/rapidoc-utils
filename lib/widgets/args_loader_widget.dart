import 'package:flutter/material.dart';
import 'package:rapidoc_utils/alerts/alert_vertical_widget.dart';
import 'package:rapidoc_utils/lang/lang.dart';
import 'package:rxdart/rxdart.dart';

class ArgsLoaderWidget<T> extends StatefulWidget {
  final Future<T?> Function() loader;
  final Function(BuildContext context, T? args) builder;
  final Function(BuildContext context, dynamic error)? errorBuilder;
  final Function(BuildContext context)? progressBuilder;

  ArgsLoaderWidget(this.loader, this.builder, {this.errorBuilder, this.progressBuilder});

  @override
  _ArgsLoaderWidgetState<T> createState() => _ArgsLoaderWidgetState<T>();
}

class _ArgsLoaderWidgetState<T> extends State<ArgsLoaderWidget<T>> {
  var lang = appLocalizationsWrapper.lang;

  final _subject = BehaviorSubject<_Data<T>>();
  bool _firstTime = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadData(BuildContext context, [bool? forceRefresh]) async {
    if (!(forceRefresh ?? false)) {
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

    try {
      var result = await widget.loader();
      _subject.add(_Data(
        data: result,
        error: null,
      ));
    } catch (error) {
      _subject.add(_Data(
        data: null,
        error: error,
      ));
    }
  }

  @override
  void dispose() {
    _subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_firstTime) {
      _loadData(context, false);
      _firstTime = false;
    }
    return StreamBuilder<_Data<T>>(
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
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return _wrapInRefreshIndicator(context, (context) => widget.builder(context, _data.data));
        }
      },
      stream: _subject,
    );
  }

  Widget _wrapInRefreshIndicator(
    BuildContext context,
    Widget Function(BuildContext context) childBuilder,
  ) {
    return RefreshIndicator(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox.fromSize(
          size: MediaQuery.of(context).size,
          child: childBuilder(context),
        ),
      ),
      onRefresh: () => _loadData(context, true),
    );
  }
}

class _Data<T> {
  final T? data;
  final dynamic error;

  _Data({required this.data, required this.error});
}
