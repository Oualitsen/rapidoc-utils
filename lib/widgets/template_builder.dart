import 'package:flutter/material.dart';
import 'package:flutter_responsive_tools/screen_type_layout.dart';

class TemplateBuilder extends StatelessWidget {
  final Widget child;
  final Widget Function(BuildContext context) drawerBuilder;
  final AppBar Function(BuildContext context) appBarBuilder;
  final Widget Function(BuildContext context)? topBuilder;
  final Widget Function(BuildContext context)? bottomBuilder;
  final Widget Function(BuildContext context)? topInnerBuilder;
  final Widget Function(BuildContext context)? bottomInnerBuilder;
  final bool disable;
  final EdgeInsets padding;

  TemplateBuilder({
    required this.child,
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
      return child;
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
                      Expanded(child: child),
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
      tabletBuilder: (context) {
        return Scaffold(
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
                              Expanded(child: child),
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
        );
      },
    );
  }
}
