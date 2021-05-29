import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  final Function(String code) onCodeRead;
  final Function()? onTimeout;
  final Function(int left)? onTick;
  final int timeout;

  CodeInputWidget({
    required this.onCodeRead,
    this.onTimeout,
    this.onTick,
    this.timeout = 30,
  });

  @override
  _CodeInputWidgetState createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  late Stream<int> _period;

  final List<FocusNode> focusNodes = [];
  final array = [];
  final List<TextFormField> fields = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 6; i++) {
      focusNodes.add(FocusNode());
      array.add("");
    }
    var onTimeout = widget.onTimeout;
    _period =
        Stream.periodic(Duration(seconds: 1), (x) => widget.timeout - x).take(widget.timeout + 1);
    if (onTimeout != null) {
      _period.where((event) => event == 0).listen((event) => onTimeout());
    }

    if (widget.onTick != null) {
      _period.listen((event) => widget.onTick!(event));
    }
  }

  @override
  Widget build(BuildContext context) {
    fields.clear();
    for (int i = 0; i < 6; i++) {
      fields.add(
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
          ),
          focusNode: focusNodes[i],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          onChanged: (text) {
            array[i] = text;
            if (text.isEmpty) {
              if (i != 0) {
                focusNodes[i - 1].requestFocus();
              }
            } else {
              if (i != 5) {
                focusNodes[i + 1].requestFocus();
              }
            }
            var readText = array.join("");
            if (readText.length == 6) {
              widget.onCodeRead(readText);
            }
          },
        ),
      );
    }

    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: GlobalKey(),
          child: Row(
            children: [
              for (int i = 0; i < 6; i++)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: fields[i],
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ));
  }
}
