import 'package:flutter/material.dart';
import 'package:flutter_responsive_tools/device_screen_type.dart';
import 'package:flutter_responsive_tools/screen_type_layout.dart';

class TemplateBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceScreenType type) childBuilder;
  final Widget Function(BuildContext context) drawerBuilder;
  final AppBar Function(BuildContext context) appBarBuilder;
  final Widget Function(BuildContext context)? topBuilder;
  final Widget Function(BuildContext context)? bottomBuilder;
  final Widget Function(BuildContext context)? topInnerBuilder;
  final Widget Function(BuildContext context)? bottomInnerBuilder;
  final bool disable;
  final EdgeInsets padding;

  TemplateBuilder({
    required this.childBuilder,
    required this.drawerBuilder,
    required this.appBarBuilder,
    this.topBuilder,
    this.bottomBuilder,
    this.topInnerBuilder,
    this.bottomInnerBuilder,
    this.disable: false,
    this.padding: const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    if (disable) {
      return childBuilder(context, DeviceScreenType.mobile);
    }

    return ScreenTypeLayout(
      mobileBuilder: (context) => Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (topBuilder != null) topBuilder!(context),
            Expanded(
              child: Scaffold(
                appBar: appBarBuilder(context),
                body: Padding(
                  padding: padding,
                  child: Column(
                    children: [
                      if (topInnerBuilder != null) topInnerBuilder!(context),
                      Expanded(child: childBuilder(context, DeviceScreenType.mobile)),
                      if (bottomInnerBuilder != null) bottomInnerBuilder!(context),
                    ],
                  ),
                ),
              ),
            ),
            if (bottomBuilder != null) bottomBuilder!(context),
          ],
        ),
      ),
      tabletBuilder: (context) => Scaffold(
        body: Row(
          children: [
            drawerBuilder(context),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (topBuilder != null) topBuilder!(context),
                  Expanded(
                    child: Scaffold(
                      appBar: appBarBuilder(context),
                      body: Padding(
                        padding: padding,
                        child: Column(
                          children: [
                            if (topInnerBuilder != null) topInnerBuilder!(context),
                            Expanded(child: childBuilder(context, DeviceScreenType.tablet)),
                            if (bottomInnerBuilder != null) bottomInnerBuilder!(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (bottomBuilder != null) bottomBuilder!(context),
                ],
              ),
            ),
          ],
        ),
      ),
      desktopBuilder: (context) => Scaffold(
        body: Row(
          children: [
            drawerBuilder(context),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (topBuilder != null) topBuilder!(context),
                  Expanded(
                    child: Scaffold(
                      appBar: appBarBuilder(context),
                      body: Padding(
                        padding: padding,
                        child: Column(
                          children: [
                            if (topInnerBuilder != null) topInnerBuilder!(context),
                            Expanded(child: childBuilder(context, DeviceScreenType.desktop)),
                            if (bottomInnerBuilder != null) bottomInnerBuilder!(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (bottomBuilder != null) bottomBuilder!(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
