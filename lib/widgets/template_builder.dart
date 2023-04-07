import 'package:flutter/material.dart';
import 'package:flutter_responsive_tools/device_screen_type.dart';
import 'package:flutter_responsive_tools/screen_type_layout.dart';

class TemplateBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceScreenType type)
      childBuilder;
  final Widget Function(BuildContext context, DeviceScreenType type)
      drawerBuilder;
  final AppBar Function(BuildContext context, DeviceScreenType type)?
      appBarBuilder;
  final Widget Function(BuildContext context, DeviceScreenType type)?
      topBuilder;
  final Widget Function(BuildContext context, DeviceScreenType type)?
      bottomBuilder;
  final Widget Function(BuildContext context, DeviceScreenType type)?
      topInnerBuilder;
  final Widget Function(BuildContext context, DeviceScreenType type)?
      bottomInnerBuilder;
  final bool disable;
  final EdgeInsets padding;

  TemplateBuilder({
    required this.childBuilder,
    required this.drawerBuilder,
    this.appBarBuilder,
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
            if (topBuilder != null)
              topBuilder!(context, DeviceScreenType.mobile),
            if (topInnerBuilder != null)
              topInnerBuilder!(context, DeviceScreenType.mobile),
            Expanded(child: childBuilder(context, DeviceScreenType.mobile)),
            if (bottomInnerBuilder != null)
              bottomInnerBuilder!(context, DeviceScreenType.mobile),
            if (bottomBuilder != null)
              bottomBuilder!(context, DeviceScreenType.mobile),
          ],
        ),
      ),
      tabletBuilder: (context) => Scaffold(
        body: Row(
          children: [
            drawerBuilder(context, DeviceScreenType.tablet),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (topBuilder != null)
                    topBuilder!(context, DeviceScreenType.tablet),
                  Expanded(
                    child: Scaffold(
                      appBar: createAppBar(context, DeviceScreenType.tablet),
                      body: Padding(
                        padding: padding,
                        child: Column(
                          children: [
                            if (topInnerBuilder != null)
                              topInnerBuilder!(
                                  context, DeviceScreenType.tablet),
                            Expanded(
                                child: childBuilder(
                                    context, DeviceScreenType.tablet)),
                            if (bottomInnerBuilder != null)
                              bottomInnerBuilder!(
                                  context, DeviceScreenType.tablet),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (bottomBuilder != null)
                    bottomBuilder!(context, DeviceScreenType.tablet),
                ],
              ),
            ),
          ],
        ),
      ),
      desktopBuilder: (context) => Scaffold(
        body: Row(
          children: [
            drawerBuilder(context, DeviceScreenType.desktop),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (topBuilder != null)
                    topBuilder!(context, DeviceScreenType.desktop),
                  Expanded(
                    child: Scaffold(
                      appBar: createAppBar(context, DeviceScreenType.desktop),
                      body: Padding(
                        padding: padding,
                        child: Column(
                          children: [
                            if (topInnerBuilder != null)
                              topInnerBuilder!(
                                  context, DeviceScreenType.desktop),
                            Expanded(
                                child: childBuilder(
                                    context, DeviceScreenType.desktop)),
                            if (bottomInnerBuilder != null)
                              bottomInnerBuilder!(
                                  context, DeviceScreenType.desktop),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (bottomBuilder != null)
                    bottomBuilder!(context, DeviceScreenType.desktop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar? createAppBar(BuildContext context, DeviceScreenType type) {
    final _appBarBuilder = appBarBuilder;
    if (_appBarBuilder == null) {
      return null;
    }
    return _appBarBuilder(context, type);
  }
}
