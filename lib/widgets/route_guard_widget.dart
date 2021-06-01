import 'package:flutter/material.dart';
import 'package:rapidoc_utils/auth_status.dart';
import 'package:rapidoc_utils/common/FullPageProgress.dart';

class RouteGuardWidget extends StatelessWidget {
  final Widget Function(BuildContext) childBuilder;
  final Widget Function(BuildContext) loggedOutBuilder;
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
          case AuthStatus.logged_in:
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
