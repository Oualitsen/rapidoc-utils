import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageUtils {
  static const double _maxRadius = 0xFFFFFFFFFF;

  static Widget fromMemory(Uint8List bytes,
      {double radius: 0.0,
      double? height,
      double? width,
      BoxFit? fit,
      double scale: 1.0}) {
    var widget = Image.memory(
      bytes,
      height: height,
      width: width,
      fit: fit,
      scale: scale,
    );
    return _setItInContainer(_addRadius(widget, radius), width, height);
  }

  static Widget fromMemoryRounded(Uint8List bytes,
      {double? height, double? width, BoxFit? fit, double scale: 1.0}) {
    return fromMemory(bytes,
        height: height,
        width: width,
        fit: fit,
        scale: scale,
        radius: _maxRadius);
  }

  static Widget fromNetwork(
    String? url, {
    double radius: 0.0,
    double? height,
    double? width,
    BoxFit? fit,
    String? placeHolder,
    Widget? placeHolderWidget,
    ImageRepeat repeat: ImageRepeat.noRepeat,
    FilterQuality filterQuality: FilterQuality.low,
    scale: 1.0,
    String? semanticLabel,
    Map<String, String>? headers,
    Widget Function(
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    )?
        loadingBuilder,
  }) {
    if (url == null) {
      return _setItInContainer(
          placeHolderWidget ?? Image.asset(placeHolder ?? 'assets/noimage.png'),
          width,
          height);
    }

    var image = Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _setItInContainer(
            placeHolderWidget ??
                Image.asset(placeHolder ?? 'assets/noimage.png'),
            width,
            height);
      },
      headers: headers,
      scale: scale,
      height: height,
      width: width,
      repeat: repeat,
      filterQuality: filterQuality,
      semanticLabel: semanticLabel,
      loadingBuilder: loadingBuilder ??
          (context, child, loadingProgress) {
            if (loadingProgress != null &&
                loadingProgress.expectedTotalBytes != null) {
              var percent = loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!;

              return Center(
                child: CircularProgressIndicator(
                  value: percent,
                ),
              );
            }
            return child;
          },
    );
    return _setItInContainer(_addRadius(image, radius), width, height);
  }

  static Widget fromNetworkRounded(
    String? url, {
    double? height,
    double? width,
    BoxFit? fit,
    String? placeHolder,
    Widget? placeHolderWidget,
    scale: 1.0,
    Map<String, String>? headers,
    Widget Function(
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    )?
        loadingBuilder,
  }) {
    return fromNetwork(
      url,
      width: width,
      height: height,
      radius: _maxRadius,
      fit: fit,
      scale: scale,
      placeHolder: placeHolder,
      placeHolderWidget: placeHolderWidget,
      headers: headers,
      loadingBuilder: loadingBuilder,
    );
  }

  static Widget fromAsset(
    String asset, {
    double radius: 0.0,
    double? height,
    double? width,
    BoxFit? fit,
    scale: 1.0,
  }) {
    var widget = Image.asset(
      asset,
      scale: scale,
      fit: fit,
      width: width,
      height: height,
    );

    return _setItInContainer(_addRadius(widget, radius), width, height);
  }

  static Widget fromAssetRounded(
    String asset, {
    double? height,
    double? width,
    BoxFit? fit,
    scale: 1.0,
  }) {
    return fromAsset(asset,
        width: width,
        height: height,
        fit: fit,
        scale: scale,
        radius: _maxRadius);
  }

  static Widget fromFile(
    File file, {
    double radius: 0.0,
    double? height,
    double? width,
    BoxFit? fit,
    scale: 1.0,
  }) {
    var widget = Image.file(
      file,
      scale: scale,
      fit: fit,
      width: width,
      height: height,
    );
    return _setItInContainer(_addRadius(widget, radius), width, height);
  }

  static Widget fromFileRounded(
    File file, {
    double radius: 0.0,
    double? height,
    double? width,
    BoxFit? fit,
    scale: 1.0,
  }) {
    return fromFile(file,
        radius: _maxRadius,
        height: height,
        width: width,
        fit: fit,
        scale: scale);
  }

  static Widget _addRadius(Widget widget, double radius) {
    if (radius == 0) {
      return widget;
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: widget,
      );
    }
  }

  static Widget _setItInContainer(Widget child, double? width, double? height) {
    if (width == null && height == null) {
      return child;
    }
    return Container(
      width: width,
      height: height,
      child: child,
    );
  }
}
