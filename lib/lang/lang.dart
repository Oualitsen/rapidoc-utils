import 'package:flutter/material.dart';
import 'package:rapidoc_utils/utils/app_localizations.dart';

final AppLocalizationsWrapper<English> appLocalizationsWrapper = AppLocalizationsWrapper({
  Locale('fr', "FR"): () => French(),
  Locale('ar', "DZ"): () => Arabic(),
  Locale('en', "US"): () => English(),
});

@protected
class English {
  String get ok => "Ok";
  String get edit => "Edit";
  String get couldNotLoadImage => "Could not load image";
  String get couldNotLoadData => "Could not load data";
  String get unknownError => "Unknown error";
  String get noInternetError => "No internet";
  String get requestTimedOut => "Request timed out";
  String get serverErrorTitle => "Server error";
  String get retry => "Retry";
  String get readErrorMessage => "Could not read image";
}

@protected
class French extends English {
  String get ok => "Ok";
  String get edit => "Modifier";
  String get couldNotLoadImage => "impossible d'ouvrir l'image";
}

@protected
class Arabic extends English {
  String get ok => "موافق";
  String get edit => "تعديل";
  String get couldNotLoadImage => "عذرًا ، تعذر التحميل";
}
