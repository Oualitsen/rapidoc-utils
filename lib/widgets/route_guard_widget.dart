import 'package:flutter/material.dart';
import 'package:rapidoc_utils/common/FullPageProgress.dart';

enum AuthStatus { STATUS_UNDEFINED, STATUS_LOGGED_OUT, STATUS_PROGRESS, STATUS_LOGGED_IN }

class RouteGuardWidget extends StatelessWidget {
  final Widget Function() childBuilder;
  final Widget Function() loggedOutBuilder;
  final Stream<AuthStatus> authStream;

  RouteGuardWidget({
    Key? key,
    required this.childBuilder,
    required this.loggedOutBuilder,
    required this.authStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthStatus>(
      stream: authStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.data) {
          case AuthStatus.STATUS_LOGGED_IN:
            return childBuilder.call();

          case AuthStatus.STATUS_LOGGED_OUT:
            return loggedOutBuilder.call();
          case AuthStatus.STATUS_PROGRESS:
            return Scaffold(body: FullPageProgress());
          default:
            return SizedBox();
        }
      },
    );
  }
}
