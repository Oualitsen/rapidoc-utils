import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rapidoc_utils/alerts/alert_info_widget.dart';
import 'package:rapidoc_utils/common/FullPageProgress.dart';
import 'package:rapidoc_utils/phone_number_input/PhoneCode.dart';
import 'package:rapidoc_utils/phone_number_input/UtilsPhoneNumber.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _persistenceKey = "phoneNumber";

class PhoneNumberInput extends StatefulWidget {
  final UtilsPhoneNumber? phoneNumber;
  final Function(UtilsPhoneNumber) onChange;
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
  late UtilsPhoneNumber _phoneNumber;

  late final TextEditingController ctrl;

  @override
  void initState() {
    super.initState();
    _phoneNumber = widget.phoneNumber ?? UtilsPhoneNumber(region: "DZ", regionCode: 213);
    ctrl = TextEditingController();
    ctrl.text = _phoneNumber.national;
  }

  Future<void> saveValue(UtilsPhoneNumber phone) async {
    if (widget.persist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_persistenceKey, jsonEncode(phone.toJson()));
    }
  }

  Future<UtilsPhoneNumber> readValue() async {
    if (widget.persist && widget.phoneNumber == null) {
      final prefs = await SharedPreferences.getInstance();
      String? phoneNumber = prefs.getString(_persistenceKey);
      try {
        if (phoneNumber != null) {
          return (UtilsPhoneNumber.fromJson(jsonDecode(phoneNumber)));
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
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
              child: Text("+${_phoneNumber.regionCode}"),
            ),
            onPressed: () async {
              var result = await showModalBottomSheet(
                  builder: (context) {
                    return FutureBuilder<List<PhoneCode>?>(
                        future: widget.phoneCodesLoader(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return AlertInfoWidget.createDanger(
                                widget.errorMessage ?? "Could not load error codes");
                          }
                          if (snapshot.connectionState == ConnectionState.done) {
                            var codes = snapshot.data ?? <PhoneCode>[];
                            return ListView(
                              children: codes
                                  .map(
                                    (code) => ListTile(
                                      leading: code.flagUrl == null
                                          ? SizedBox.shrink()
                                          : ClipRRect(
                                              borderRadius: BorderRadius.circular(0xFFFFFFFFFF),
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
                          }

                          return FullPageProgress();
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
            child: FutureBuilder<UtilsPhoneNumber>(
                future: readValue(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox.shrink();
                  }
                  _phoneNumber = snapshot.data!;
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
