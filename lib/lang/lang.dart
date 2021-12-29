import 'package:flutter/material.dart';
import 'package:rapidoc_utils/utils/app_localizations.dart';

final AppLocalizationsWrapper<English> appLocalizationsWrapper =
    AppLocalizationsWrapper({
  Locale('fr', ''): () => French(),
  Locale('ar', ''): () => Arabic(),
  Locale('en', ''): () => English(),
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
  String get usePhoneInstead => "Use phone number";
  String get useEmailInstead => "Use email";

  String get requiredField => "Required field";

  String get invalidEmailFormat => "This email does not look valid";
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
