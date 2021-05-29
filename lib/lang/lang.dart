import 'package:flutter/material.dart';
import 'package:rapidoc_multilang/app_localizations.dart';

final AppLocalizationsWrapper appLocalizationsWrapper = AppLocalizationsWrapper({
  Locale('fr', "FR"): () => French(),
  Locale('ar', "DZ"): () => Arabic(),
  Locale('en', "US"): () => English(),
});

class English {
  String get ok => "Ok";
  String get edit => "Edit";
  String get couldNotLoadImage => "Could not load image";
}

class French extends English {
  String get ok => "Ok";
  String get edit => "Modifier";
  String get couldNotLoadImage => "impossible d'ouvrir l'image";
}

class Arabic extends English {
  String get ok => "موافق";
  String get edit => "تعديل";
  String get couldNotLoadImage => "عذرًا ، تعذر التحميل";
}
