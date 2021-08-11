import 'package:flutter/material.dart';
import 'package:rapidoc_utils/utils/app_localizations.dart';

final AppLocalizationsWrapper<English> appLocalizationsWrapper =
    AppLocalizationsWrapper({
  Locale('fr', "FR"): () => French(),
  Locale('ar', "DZ"): () => Arabic(),
  Locale('en', "US"): () => English(),
});

@protected
class English {
  String get ok => "Ok";
  String get cancel => "Cancel";
  String get yes => "Yes";
  String get no => "No";

  String get edit => "Edit";
  String get couldNotLoadImage => "Could not load image";
  String get couldNotLoadData => "Could not load data";
  String get unknownError => "Unknown error";
  String get noInternetError => "No internet";
  String get requestTimedOut => "Request timed out";
  String get serverErrorTitle => "Server error";
  String get retry => "Retry";
  String get readErrorMessage => "Could not read image";
  String get dataNotFound => "Not found";
}

@protected
class French extends English {
  String get ok => "Ok";
  String get cancel => "Annuler";

  String get yes => "Oui";
  String get no => "Non";

  String get edit => "Modifier";
  String get couldNotLoadImage => "impossible d'ouvrir l'image";
}

@protected
class Arabic extends English {
  String get ok => "موافق";
  String get cancel => "إلغاء";

  String get yes => "نعم";
  String get no => "لا";

  String get edit => "تعديل";
  String get couldNotLoadImage => "عذرًا ، تعذر التحميل";
}
