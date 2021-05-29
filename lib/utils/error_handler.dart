import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rapidoc_utils/lang/lang.dart';
import 'package:rapidoc_utils/utils/Utils.dart';

void showServerError(BuildContext context, {error}) {
  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.cancel:
        /**
       * Ignore this error.
       */
        break;
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        _showTimedOut(context);
        break;
      case DioErrorType.response:
        _showServerError(
          context,
          error.response!.statusMessage!,
          error.response!.statusCode!,
        );

        break;
      case DioErrorType.other:
        _showDefaultError(context);
        break;
    }
  } else {
    _showUnknownError(context);
  }
}

void _showUnknownError(BuildContext context) {
  var lang = appLocalizationsWrapper.lang;
  showSnackBar(
      SnackBar(
        content: Text(lang.unknownError),
        action: SnackBarAction(
          label: lang.ok.toUpperCase(),
          onPressed: () {},
        ),
      ),
      context);
}

void _showDefaultError(BuildContext context) {
  var lang = appLocalizationsWrapper.lang;
  showSnackBar(
      SnackBar(
        content: Wrap(
          children: [
            Icon(
              Icons.wifi_off,
              color: Theme.of(context).accentColor,
            ),
            SizedBox(width: 5),
            Text(
              lang.noInternetError,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: lang.ok.toUpperCase(),
          onPressed: () {},
        ),
      ),
      context);
}

void _showTimedOut(BuildContext context) {
  var lang = appLocalizationsWrapper.lang;
  showSnackBar(
      SnackBar(
        content: Text(lang.requestTimedOut),
        action: SnackBarAction(
          label: lang.ok.toUpperCase(),
          onPressed: () {},
        ),
      ),
      context);
}

void _showServerError(
  BuildContext context,
  String statusMessage,
  int statusCode,
) {
  var lang = appLocalizationsWrapper.lang;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(lang.serverErrorTitle),
        content: Text("$statusCode $statusMessage"),
        actions: <Widget>[
          TextButton(
            child: Text(lang.ok.toUpperCase()),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      );
    },
  );
}
