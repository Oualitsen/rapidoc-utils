import 'dart:async';

import 'package:flutter/material.dart';

class AppLocalizationsWrapper<T> {
  Map<Locale, T Function()> langMap;
  AppLocalizations<T> appLocalizations;

  AppLocalizationsWrapper(this.langMap)
      : appLocalizations = AppLocalizations<T>(
          langMap.keys.first,
          langMap[langMap.keys.first]!(),
        );

  LocalizationsDelegate<AppLocalizations<T>>? _delegate;

  LocalizationsDelegate<AppLocalizations<T>> get delegate {
    if (_delegate == null) {
      _delegate = _AppLocalizationsDelegate<T>(langMap, (app) => appLocalizations = app);
    }
    return _delegate!;
  }

  void setLocale(Locale locale) {
    appLocalizations = AppLocalizations(locale, langMap[locale]!());
  }

  T get lang => appLocalizations.lang;

  Locale get locale => appLocalizations.locale;
}

class AppLocalizations<T> {
  final T lang;
  final Locale locale;
  AppLocalizations(this.locale, this.lang);

  bool isR2L() {
    return locale.languageCode == "ar";
  }
}

class _AppLocalizationsDelegate<T> extends LocalizationsDelegate<AppLocalizations<T>> {
  final Map<Locale, T Function()> langMap;
  final Function(AppLocalizations<T> loc) onChange;

  const _AppLocalizationsDelegate(this.langMap, this.onChange);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;

  @override
  Future<AppLocalizations<T>> load(Locale locale) {
    T lang = langMap[locale]!();
    final localizations = AppLocalizations<T>(locale, lang);
    onChange(localizations);
    return Future.value(localizations);
  }

  @override
  bool isSupported(Locale locale) {
    var keys = langMap.keys;
    for (Locale l in keys) {
      if (l.languageCode == locale.languageCode) {
        if ([null, '', '*', locale.countryCode].contains(l.countryCode)) {
          return true;
        }
      }
    }
    return false;
  }
}
