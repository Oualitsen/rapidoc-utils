import 'package:flutter/material.dart';
import 'package:rapidoc_utils/alerts/alert_info_widget.dart';
import 'package:rapidoc_utils/lang/lang.dart';
import 'package:rapidoc_utils/phone_number_input/phone_code.dart';
import 'package:rapidoc_utils/phone_number_input/phone_number.dart';
import 'package:rapidoc_utils/phone_number_input/email_input_widget.dart';
import 'package:rapidoc_utils/phone_number_input/phone_number_input.dart';
import 'package:rxdart/rxdart.dart';

enum PhoneEmailInputType { phoneNumber, email }

class PhoneEmailInputWidget extends StatefulWidget {
  final bool showAlternative;
  final PhoneNumber? initial;
  final String? initialEmail;

  final String? phoneNotice;
  final String? emailNotice;

  final String Function(bool email)? labelFunction;
  final String? switchToEmailLabel;
  final String? switchToPhoneNumberLabel;

  final String? emailLabel;
  final String? phoneLabel;
  final PhoneEmailInputType type;

  final Future<List<PhoneCode>?> Function() phoneCodesLoader;

  final void Function(String email)? onEmailRead;
  final void Function(PhoneNumber phoneNumber)? onPhoneNumberRead;
  final bool persist;
  final bool valueRequired;

  PhoneEmailInputWidget({
    this.showAlternative: true,
    this.persist: false,
    this.valueRequired: false,
    this.initial,
    this.phoneNotice,
    this.emailNotice,
    this.initialEmail,
    this.labelFunction,
    this.switchToEmailLabel,
    this.switchToPhoneNumberLabel,
    this.emailLabel,
    this.phoneLabel,
    this.type: PhoneEmailInputType.phoneNumber,
    required this.phoneCodesLoader,
    required this.onEmailRead,
    required this.onPhoneNumberRead,
  });

  @override
  _PhoneEmailInputWidgetState createState() => _PhoneEmailInputWidgetState();
}

class _PhoneEmailInputWidgetState extends State<PhoneEmailInputWidget> {
  late final BehaviorSubject<PhoneEmailInputType> _typeSubject;

  final lang = appLocalizationsWrapper.lang;

  final emailKey = GlobalKey<EmailInputWidgetState>();
  final phoneKey = GlobalKey<PhoneNumberInputState>();

  @override
  void initState() {
    super.initState();
    _typeSubject = BehaviorSubject.seeded(widget.type);
  }

  @override
  void dispose() {
    _typeSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: <Widget>[
        StreamBuilder<PhoneEmailInputType>(
            stream: _typeSubject,
            initialData: _typeSubject.valueOrNull,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var type = snapshot.data!;
                String? text;
                switch (type) {
                  case PhoneEmailInputType.phoneNumber:
                    text = widget.phoneLabel;
                    break;
                  case PhoneEmailInputType.email:
                    text = widget.emailLabel;
                    break;
                }

                if (text != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(text),
                  );
                }
              }
              return SizedBox.shrink();
            }),
        StreamBuilder(
          stream: _typeSubject,
          initialData: _typeSubject.value,
          builder: (context, AsyncSnapshot<PhoneEmailInputType> snap) {
            if (!snap.hasData) {
              return SizedBox.shrink();
            }

            switch (snap.data!) {
              case PhoneEmailInputType.email:
                return Column(
                  children: [
                    EmailInputWidget(
                      valueRequired: widget.valueRequired,
                      persist: widget.persist,
                      key: emailKey,
                      initial: widget.initialEmail,
                    ),
                    if (widget.emailNotice != null)
                      AlertInfoWidget.createInfo(widget.emailNotice!),
                  ],
                );
              case PhoneEmailInputType.phoneNumber:
                return Column(
                  children: [
                    PhoneNumberInput(
                      key: phoneKey,
                      phoneCodesLoader: widget.phoneCodesLoader,
                      persist: widget.persist,
                      phoneNumber: widget.initial,
                    ),
                    if (widget.phoneNotice != null)
                      AlertInfoWidget.createInfo(widget.phoneNotice!),
                  ],
                );
            }
          },
        ),
        if (widget.showAlternative) ...[
          SizedBox(height: 30),
          StreamBuilder(
            stream: _typeSubject,
            initialData: _typeSubject.value,
            builder: (context, AsyncSnapshot<PhoneEmailInputType> snap) {
              var value = snap.data;

              if (value == null) {
                return SizedBox.shrink();
              }

              String text;

              switch (snap.data!) {
                case PhoneEmailInputType.phoneNumber:
                  text = widget.switchToPhoneNumberLabel ??
                      lang.usePhoneInstead.toUpperCase();
                  break;
                case PhoneEmailInputType.email:
                  text = widget.switchToEmailLabel ??
                      lang.useEmailInstead.toUpperCase();
                  break;
              }

              return OutlinedButton(
                child: Text(text),
                onPressed: () {
                  var current = _typeSubject.value;
                  switch (current) {
                    case PhoneEmailInputType.phoneNumber:
                      _typeSubject.add(PhoneEmailInputType.email);
                      break;
                    case PhoneEmailInputType.email:
                      _typeSubject.add(PhoneEmailInputType.phoneNumber);
                      break;
                  }
                },
              );
            },
          ),
        ],
      ],
    );
  }

  bool read() {
    var type = _typeSubject.value;
    switch (type) {
      case PhoneEmailInputType.phoneNumber:
        var state = phoneKey.currentState;
        if (state != null) {
          var fn = widget.onPhoneNumberRead;
          var pn = state.read();
          if (pn != null && fn != null) {
            fn(pn);
          }
        }

        break;
      case PhoneEmailInputType.email:
        var state = emailKey.currentState;
        if (state != null) {
          var email = state.read();
          var fn = widget.onEmailRead;
          if (email != null && fn != null) {
            fn(email);
          }
        }

        break;
    }

    return false;
  }
}
