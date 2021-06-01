import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDrawer extends StatefulWidget {
  final bool collapsible;

  final DrawerHeader? header;
  final bool hideHeaderOnCollapse;
  final Color background;
  final List<DrawerMenuItem> items;

  MenuDrawer({
    required this.items,
    this.collapsible: false,
    this.header,
    this.hideHeaderOnCollapse: true,
    this.background: Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> with SingleTickerProviderStateMixin {
  final _drawerStateKey = "_drawer_state";

  final double collapsedSize = 80;
  final double expandedSize = 320;

  final double iconCollapsedSized = 32;
  final double iconExpandedSized = 24;

  final BehaviorSubject<bool> drawerSubject = BehaviorSubject.seeded(false);

  late double width;

  bool collapsed = false;

  late StreamSubscription sub;

  @override
  void initState() {
    sub = drawerSubject.listen((value) {
      setState(() {});
      collapsed = value;
    });
    readDrawerState().then((value) {
      _setCollapsed(value);
    });
    super.initState();
  }

  @override
  void dispose() {
    drawerSubject.close();
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (widget.header != null) children.add(widget.header!);
    children.addAll(widget.items.map((e) {
      return Tooltip(
        message: e.tooltipText ?? e.title,
        child: ListTile(
          title: getMenuTitleWidget(e.title),
          leading: Icon(
            Icons.article,
            size: iconSize,
          ),
          onTap: e.onTap,
        ),
      );
    }).toList());

    return AnimatedSize(
      curve: Curves.easeIn,
      vsync: this,
      duration: Duration(milliseconds: 100),
      child: Container(
        width: width,
        color: widget.background,
        child: ListView(
          children: children,
        ),
      ),
    );
  }

  get iconSize {
    if (!widget.collapsible) {
      return 24.0;
    }
    return drawerSubject.value ? 36.0 : 24.0;
  }

  saveDrawerState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_drawerStateKey, drawerSubject.value);
  }

  Future<bool> readDrawerState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool? value = preferences.getBool(_drawerStateKey);
    return value ?? false;
  }

  void _setCollapsed(bool collapsed) {
    drawerSubject.add(collapsed);
    setState(() {
      width = drawerSubject.value ? collapsedSize : expandedSize;
    });
    saveDrawerState();
  }

  Widget getMenuTitleWidget(String title, [TextOverflow? overflow]) {
    if (!widget.collapsible) {
      return Text(
        title,
        overflow: overflow ?? TextOverflow.ellipsis,
      );
    }

    return (drawerSubject.value)
        ? SizedBox.shrink()
        : Text(
            title,
            overflow: overflow ?? TextOverflow.ellipsis,
          );
  }
}

class DrawerMenuItem {
  final String title;
  final Function() onTap;
  final Icon? icon;

  final String? subtitle;
  final String? tooltipText;

  DrawerMenuItem({
    required this.title,
    required this.onTap,
    this.icon,
    this.subtitle,
    this.tooltipText,
  });
}
