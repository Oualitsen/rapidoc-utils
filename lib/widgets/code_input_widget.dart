import 'package:flutter/material.dart';

class CodeInputWidget extends StatefulWidget {
  final Function(String code) onCodeRead;
  final Function()? onTimeout;
  final Function(int left)? onTick;
  final int timeout;

  CodeInputWidget({
    Key? key,
    required this.onCodeRead,
    this.onTimeout,
    this.onTick,
    this.timeout = 30,
  }) : super(key: key);

  @override
  CodeInputWidgetState createState() => CodeInputWidgetState();
}

class CodeInputWidgetState extends State<CodeInputWidget> {
  late Stream<int> _period;

  final List<TextEditingController> controllers = [];

  final List<FocusNode> focusNodes = [];
  final array = <String>[];
  final List<TextFormField> fields = [];

  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 6; i++) {
      focusNodes.add(FocusNode());
      array.add("");
      controllers.add(TextEditingController());
    }
    var onTimeout = widget.onTimeout;
    _period = Stream.periodic(Duration(seconds: 1), (x) => widget.timeout - x)
        .take(widget.timeout + 1);
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
          controller: controllers[i],
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
          ),
          focusNode: focusNodes[i],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          validator: _validator,
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
          key: _key,
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

  String? _validator(String? text) => (text?.isEmpty ?? false) ? "" : null;

  String? read() {
    var _state = _key.currentState;
    if (_state != null && _state.validate()) {
      return array.join("");
    }
    return null;
  }
}
