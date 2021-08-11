import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rapidoc_utils/alerts/alert_info_widget.dart';
import 'package:rapidoc_utils/phone_number_input/PhoneCode.dart';
import 'package:rapidoc_utils/phone_number_input/PhoneNumber.dart';
import 'package:rapidoc_utils/widgets/args_loader_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _persistenceKey = "phoneNumber";

class PhoneNumberInput extends StatefulWidget {
  final PhoneNumber? phoneNumber;
  final Function(PhoneNumber) onChange;
  final bool persist;
  final Future<List<PhoneCode>?> Function() phoneCodesLoader;
  final String? errorMessage;
  final String? hintText;

  PhoneNumberInput({
    Key? key,
    this.phoneNumber,
    required this.onChange,
    required this.phoneCodesLoader,
    this.persist: false,
    this.errorMessage,
    this.hintText,
  }) : super(key: key);

  @override
  PhoneNumberInputState createState() => PhoneNumberInputState();
}

class PhoneNumberInputState extends State<PhoneNumberInput> {
  late PhoneNumber _phoneNumber;

  late final TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    _phoneNumber =
        widget.phoneNumber ?? PhoneNumber(region: "DZ", regionCode: 213);
    ctrl = TextEditingController();
    ctrl.text = _phoneNumber.national;
  }

  Future<void> saveValue(PhoneNumber phone) async {
    if (widget.persist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_persistenceKey, jsonEncode(phone.toJson()));
    }
  }

  Future<PhoneNumber> readValue() async {
    if (widget.persist && widget.phoneNumber == null) {
      final prefs = await SharedPreferences.getInstance();
      String? phoneNumber = prefs.getString(_persistenceKey);
      try {
        if (phoneNumber != null) {
          return (PhoneNumber.fromJson(jsonDecode(phoneNumber)));
        }
      } catch (error) {
        print("Error $error");
      }
    }
    return _phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    if (_phoneNumber.national.isNotEmpty) {
      widget.onChange(_phoneNumber);
    }

    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          OutlinedButton(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 10, right: 10),
              child: Text("+${_phoneNumber.regionCode}"),
            ),
            onPressed: () async {
              var result = await showModalBottomSheet(
                  builder: (context) {
                    return ArgsLoaderWidget<List<PhoneCode>>(
                        ignoreModalRouteArgument: true,
                        loader: () => widget.phoneCodesLoader(),
                        errorBuilder: (_, __) => AlertInfoWidget.createDanger(
                            widget.errorMessage ??
                                "Could not load error codes"),
                        builder: (context, codes) {
                          return ListView(
                            children: codes
                                .map(
                                  (code) => ListTile(
                                    leading: code.flagUrl == null
                                        ? SizedBox.shrink()
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                0xFFFFFFFFFF),
                                            child: Image.network(
                                              code.flagUrl!,
                                              width: 64,
                                              height: 64,
                                            ),
                                          ),
                                    title: Text(code.dial),
                                    subtitle: Text(code.name),
                                    onTap: () {
                                      Navigator.of(context).pop(code);
                                    },
                                  ),
                                )
                                .toList(),
                          );
                        });
                  },
                  context: context);

              if (result != null) {
                var code = result as PhoneCode;
                setState(() {
                  _phoneNumber.regionCode = int.parse(code.dial.substring(1));
                  _phoneNumber.region = code.code;
                  widget.onChange(_phoneNumber);
                });
              }
            },
          ),
          SizedBox(width: 5),
          Expanded(
            child: ArgsLoaderWidget<PhoneNumber>(
                ignoreModalRouteArgument: true,
                loader: () => readValue(),
                progressBuilder: (_) => SizedBox.shrink(),
                builder: (context, number) {
                  _phoneNumber = number;
                  ctrl.text = _phoneNumber.national;

                  return TextField(
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    controller: ctrl,
                    onChanged: (text) {
                      _phoneNumber.national = text;
                      widget.onChange(_phoneNumber);
                      saveValue(_phoneNumber);
                    },
                    decoration: InputDecoration(
                      hintText: widget.hintText ?? "Phone number",
                      border: OutlineInputBorder(),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
