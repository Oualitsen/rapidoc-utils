import 'package:flutter/material.dart';
import 'package:rapidoc_utils/lang/lang.dart';
import 'package:rapidoc_utils/widgets/args_loader_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

RegExp emailRegExp = RegExp(
  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$",
);
const _persistenceKey = "email";

class EmailInputWidget extends StatefulWidget {
  final String? initial;
  final bool valueRequired;
  final bool persist;
  const EmailInputWidget({
    Key? key,
    this.initial,
    required this.valueRequired,
    this.persist: false,
  }) : super(key: key);

  @override
  EmailInputWidgetState createState() => EmailInputWidgetState();
}

class EmailInputWidgetState extends State<EmailInputWidget> {
  final lang = appLocalizationsWrapper.lang;

  final _formKey = GlobalKey<FormState>();
  final ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ArgsLoaderWidget<String>(
      ignoreModalRouteArgument: true,
      loader: _read,
      builder: (context, email) {
        ctrl.text = email;
        return Form(
          key: _formKey,
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (text) {
              if (text == null || text.isEmpty) {
                if (widget.valueRequired) {
                  return lang.requiredField;
                } else {
                  return null;
                }
              } else {
                if (!emailRegExp.hasMatch(text)) {
                  return lang.invalidEmailFormat;
                }
              }
              return null;
            },
          ),
        );
      },
    );
  }

  String? read() {
    var state = _formKey.currentState;
    if (state != null) {
      if (state.validate()) {
        if (widget.persist) {
          save(ctrl.text);
        }
        return ctrl.text;
      }
    }
    return null;
  }

  Future<bool> save(String email) async {
    var sp = await SharedPreferences.getInstance();
    return sp.setString(_persistenceKey, email);
  }

  Future<String> _read() async {
    if (widget.persist) {
      var sp = await SharedPreferences.getInstance();
      var result = sp.getString(_persistenceKey);
      return result ?? "";
    }
    return widget.initial ?? "";
  }
}
