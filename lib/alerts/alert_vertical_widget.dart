import 'package:flutter/material.dart';

enum AlertType { INFO, WARNING, DANGER }

class AlertVerticalWidget extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final AlertType type;
  final bool raised;
  final double margin;
  final double iconSize;

  AlertVerticalWidget(this.text,
      {this.iconData = Icons.info_outline,
      this.type: AlertType.INFO,
      this.raised: false,
      this.iconSize: 64,
      this.margin: 10});

  static AlertVerticalWidget createInfo(String text,
      {iconData = Icons.info_outline, raised: false, double margin: 10, double iconSize: 64}) {
    return AlertVerticalWidget(
      text,
      type: AlertType.INFO,
      iconData: iconData,
      raised: raised,
      margin: margin,
      iconSize: iconSize,
    );
  }

  static AlertVerticalWidget createWarning(String text,
      {iconData = Icons.warning, raised: false, double margin: 10, double iconSize: 64}) {
    return AlertVerticalWidget(
      text,
      type: AlertType.WARNING,
      iconData: iconData,
      raised: raised,
      iconSize: iconSize,
      margin: margin,
    );
  }

  static AlertVerticalWidget createDanger(String text,
      {iconData = Icons.info, raised: false, double margin: 10, double iconSize: 64}) {
    return AlertVerticalWidget(
      text,
      type: AlertType.DANGER,
      iconData: iconData,
      raised: raised,
      margin: margin,
      iconSize: iconSize,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            iconData == null
                ? SizedBox.shrink()
                : Icon(
                    iconData,
                    color: _getTextColor(),
                    size: iconSize,
                  ),
            SizedBox(
              height: iconData == null ? 0 : 16,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _getTextColor(),
              ),
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
