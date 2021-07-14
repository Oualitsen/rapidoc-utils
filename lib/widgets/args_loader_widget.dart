import 'package:flutter/material.dart';
import 'package:rapidoc_utils/alerts/alert_vertical_widget.dart';
import 'package:rapidoc_utils/lang/lang.dart';

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
  T? _cache;
  var lang = appLocalizationsWrapper.lang;
  @override
  Widget build(BuildContext context) {
    if (_cache != null) {
      return widget.builder(context, _cache);
    } else {
      return FutureBuilder<T?>(
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            if (widget.errorBuilder != null) {
              return widget.errorBuilder!(context, snapShot.error);
            } else {
              return Center(
                child: AlertVerticalWidget.createDanger(lang.couldNotLoadData),
              );
            }
          }

          if (snapShot.connectionState == ConnectionState.done) {
            return widget.builder(context, snapShot.data);
          }
          if (widget.progressBuilder != null) {
            return widget.progressBuilder!(context);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: widget.loader(),
      );
    }
  }
}
