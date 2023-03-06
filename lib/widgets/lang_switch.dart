import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rapidoc_utils/widgets/image_utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangSwitch extends StatefulWidget {
  final Function(Locale) onChange;
  final String Function(Locale)? flagUrl;
  final String Function(Locale)? langName;
  final bool showFullName;
  final bool showFlag;
  final List<Locale> locales;
  final bool hideSelected;
  final bool persist;

  const LangSwitch({
    Key? key,
    required this.onChange,
    required this.locales,
    this.flagUrl,
    this.langName,
    this.showFlag: true,
    this.showFullName: true,
    this.hideSelected: true,
    this.persist: true,
  })  : assert(locales.length != 0, "Locales must not be empty"),
        super(key: key);

  @override
  _LangSwitchState createState() => _LangSwitchState();
}

class _LangSwitchState extends State<LangSwitch> {
  BehaviorSubject<Locale> _subject = BehaviorSubject<Locale>();
  late StreamSubscription _sub;
  final localeKey = "lang_switch_locale";

  @override
  void initState() {
    _sub = _subject.listen((val) async {
      widget.onChange(val);
      await _saveLocale(val);
    });
    _readLocale().then((value) => _subject.add(value));
    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
        stream: _subject,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();
          Locale selected = snapshot.data!;

          return PopupMenuButton(
            onSelected: _subject.add,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      if (widget.showFlag) _getFlag(selected),
                      if (widget.showFlag) SizedBox(width: 10),
                      Text(
                        widget.showFullName
                            ? _getLangName(selected)
                            : selected.languageCode.toUpperCase(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            itemBuilder: (context) {
              return widget.locales
                  .where(
                    (element) => widget.hideSelected && element != selected,
                  )
                  .map(
                    (e) => PopupMenuItem(
                      child: Row(
                        children: [
                          _getFlag(e),
                          SizedBox(width: 10),
                          Text(_getLangName(e)),
                        ],
                      ),
                      value: e,
                    ),
                  )
                  .toList();
            },
          );
        });
  }

  Widget _getFlag(Locale l) {
    if (widget.flagUrl != null) {
      return ImageUtils.fromNetwork(widget.flagUrl!(l), width: 24, height: 24);
    }
    return SizedBox.shrink();
  }

  String _getLangName(Locale l) {
    if (widget.langName != null) {
      return widget.langName!(l);
    }
    return l.languageCode;
  }

  _saveLocale(Locale _locale) async {
    if (widget.persist) {
      String value = "${_locale.languageCode}-${_locale.countryCode}";
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(localeKey, value);
    }
  }

  Future<Locale> _readLocale() async {
    if (!widget.persist) {
      return _subject.valueOrNull ?? widget.locales.first;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value = preferences.getString(localeKey);
    try {
      if (value != null) {
        var split = value.split("-");
        if (split.length == 1) {
          return Locale(split[0], '');
        }
        return Locale(split[0], split[1]);
      }
    } catch (error) {
      /**
       * Ignore this error
       */
    }
    var first = widget.locales.first;
    _saveLocale(first);

    return first;
  }
}
