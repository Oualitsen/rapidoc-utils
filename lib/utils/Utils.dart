import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:http_error_handler/error_handler.dart';
import 'package:rapidoc_utils/alerts/alert_vertical_widget.dart';
import 'package:rapidoc_utils/lang/lang.dart';
import 'package:rapidoc_utils/routes/image_file_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

Future<String?> _getImageWeb(context) async {
  final html.InputElement input =
      html.document.createElement("input") as html.InputElement;
  input
    ..type = "file"
    ..accept = "image/*";

  var completer = Completer<String>();

  input.onChange.listen((e) async {
    if (input.files?.isEmpty ?? true) {
      return null;
    }
    final reader = html.FileReader();

    reader.readAsDataUrl(input.files![0]);
    reader.onError.listen((event) {
      completer.completeError(event);
    });
    await reader.onLoadEnd.first;
    completer.complete(Future.value(reader.result as String?));
  });
  input.click();
  return completer.future;
}

Future<String?> readImagePath({
  required context,
  ImageSource source = ImageSource.camera,
  bool preview = true,
}) async {
  String? data;
  if (kIsWeb) {
    data = await _getImageWeb(context);
    return data;
  } else {
    var ip = ImagePicker();
    return ip
        .pickImage(source: source)
        .asStream()
        .where((event) => event != null)
        .map((event) => event!)
        .map((event) => event.path)
        .first;
  }
}

Future<T?> safeCall<T>(Future<T> future, [BuildContext? context]) async {
  try {
    var result = await future;
    return result;
  } catch (error) {
    if (context != null) {
      showServerError(context, error: error);
    }
  }
  return null;
}

Widget errorWidget(BuildContext context,
    {Function()? callback, Object? error}) {
  var lang = appLocalizationsWrapper.lang;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(child: AlertVerticalWidget.createDanger(lang.couldNotLoadData)),
      if (callback != null)
        TextButton(
          child: Text(lang.retry.toUpperCase()),
          onPressed: () => callback.call(),
        )
    ],
  );
}

List<List<double>> decodePoly(String encoded) {
  List<List<double>> poly = [];
  int index = 0, len = encoded.length;
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded[index++].codeUnitAt(0) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded[index++].codeUnitAt(0) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    List<double> p = [lat / 1e5, lng / 1e5];

    poly.add(p);
  }

  return poly;
}

Future<Uint8List?> getImageFromLocalStorage() async {
  var prefs = await SharedPreferences.getInstance();
  String? base = prefs.getString(LOC_STORAGE_KEY);
  if (base != null) {
    return base64
        .decode(base.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), ''));
  }
  return null;
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<Position> getCurrentPosition({
  LocationAccuracy desiredAccuracy = LocationAccuracy.medium,
  bool forceAndroidLocationManager = false,
  Duration? timeLimit: const Duration(seconds: 7),
}) {
  return Geolocator.getCurrentPosition(
    desiredAccuracy: desiredAccuracy,
    forceAndroidLocationManager: forceAndroidLocationManager,
    timeLimit: timeLimit,
  ).asStream().first;
}

Future showAlertDialog(
    {required BuildContext context,
    String? title,
    String? message,
    List<Widget>? actions}) async {
  var result = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title ?? ""),
      content: Text(message ?? ""),
      actions: (actions?.isEmpty ?? true)
          ? <Widget>[
              TextButton(
                child: Text(appLocalizationsWrapper.lang.ok.toUpperCase()),
                onPressed: () => Navigator.of(context).pop(),
              )
            ]
          : actions,
    ),
  );
  return result;
}

class DialogButtons {
  static var lang = appLocalizationsWrapper.lang;

  static List<Widget> yesNoButtons(BuildContext context) {
    return getButtons(context, {
      lang.no.toUpperCase(): false,
      lang.yes.toUpperCase(): true,
    });
  }

  static List<Widget> okCancelButtons(BuildContext context) {
    return getButtons(context, {
      lang.cancel.toUpperCase(): false,
      lang.ok.toUpperCase(): true,
    });
  }

  static List<Widget> getButtons(
      BuildContext context, Map<String, dynamic> map) {
    return map.keys
        .map((e) => TextButton(
              onPressed: () => Navigator.of(context).pop(map[e]),
              child: Text(e),
            ))
        .toList();
  }
}
