import 'package:flutter/material.dart';
import 'package:rapidoc_utils/auth_status.dart';
import 'package:rapidoc_utils/common/FullPageProgress.dart';

class RouteGuardWidget extends StatelessWidget {
  final Widget Function(BuildContext) childBuilder;
  final Widget Function(BuildContext) loggedOutBuilder;
  final Widget Function(BuildContext)? completeInfoBuilder;
  final Stream<AuthStatus> authStream;
  final bool Function()? needsToCompleteInfo;

  RouteGuardWidget({
    Key? key,
    required this.childBuilder,
    required this.loggedOutBuilder,
    required this.authStream,
    this.needsToCompleteInfo,
    this.completeInfoBuilder,
  })  : assert(
            needsToCompleteInfo != null && completeInfoBuilder != null ||
                needsToCompleteInfo == null && completeInfoBuilder == null,
            "Arguments needsToCompleteInfo and completeInfoBuilder must be either both null or both non null"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthStatus>(
      stream: authStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.data) {
          case AuthStatus.logged_in:
            if (needsToCompleteInfo != null && needsToCompleteInfo!()) {
              return completeInfoBuilder!(context);
            }
            return childBuilder(context);

          case AuthStatus.logged_out:
            return loggedOutBuilder(context);
          case AuthStatus.progress:
            return Scaffold(body: FullPageProgress());
          default:
            return SizedBox();
        }
      },
    );
  }
}
