import 'package:flutter/material.dart';

enum AlertType { INFO, WARNING, DANGER }

class AlertInfoWidget extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final AlertType type;
  final bool raised;
  final double margin;

  AlertInfoWidget(
    this.text, {
    this.iconData = Icons.info_outline,
    this.type: AlertType.INFO,
    this.raised: false,
    this.margin: 10,
  });

  static AlertInfoWidget createInfo(String text,
      {iconData = Icons.info_outline, raised: false, double margin: 10}) {
    return AlertInfoWidget(
      text,
      type: AlertType.INFO,
      iconData: iconData,
      raised: raised,
      margin: margin,
    );
  }

  static AlertInfoWidget createWarning(String text,
      {iconData = Icons.warning, raised: false, double margin: 10}) {
    return AlertInfoWidget(
      text,
      type: AlertType.WARNING,
      iconData: iconData,
      raised: raised,
      margin: margin,
    );
  }

  static AlertInfoWidget createDanger(String text,
      {iconData = Icons.info, raised: false, double margin: 10}) {
    return AlertInfoWidget(
      text,
      type: AlertType.DANGER,
      iconData: iconData,
      raised: raised,
      margin: margin,
    );
  }

  Color _getTextColor() {
    if (raised) {
      return Colors.white;
    }
    switch (type) {
      case AlertType.INFO:
        return Colors.blueAccent;
      case AlertType.WARNING:
        return Colors.orange;
      case AlertType.DANGER:
        return Colors.redAccent;
    }
  }

  Color _getBackGroundColor() {
    if (raised) {
      switch (type) {
        case AlertType.INFO:
          return Colors.blueAccent;
        case AlertType.WARNING:
          return Colors.orange;
        case AlertType.DANGER:
          return Colors.redAccent;
      }
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _getBackGroundColor(),
          border: Border.all(
            color: raised ? _getTextColor() : _getBackGroundColor(),
          ),
          borderRadius: BorderRadius.circular(7)),
      margin: EdgeInsets.all(margin),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            iconData == null
                ? SizedBox.shrink()
                : Icon(
                    iconData,
                    color: _getTextColor(),
                  ),
            SizedBox(
              width: iconData == null ? 0 : 16,
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: _getTextColor(),
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
