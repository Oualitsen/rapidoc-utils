import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:rapidoc_utils/auth_status.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager<T> {
  final String key = 'auth_manager_user_key';
  final BehaviorSubject<AuthStatus> subject = BehaviorSubject.seeded(AuthStatus.undefined);

  final BehaviorSubject<T?> userSubject = BehaviorSubject();

  final T Function(Map<String, dynamic>) parser;
  final Map<String, dynamic> Function(T user) serializer;
  final Future<T?> Function(T? current)? getUserFromServer;
  late StreamSubscription _subscription;

  AuthManager({
    required this.parser,
    required this.serializer,
    this.getUserFromServer,
  }) {
    _init();
  }

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    _subscription = userSubject.listen((value) {
      if (value == null) {
        subject.add(AuthStatus.logged_out);
      } else {
        subject.add(AuthStatus.logged_in);
      }
    });

    String? value = prefs.getString(key);
    if (value != null) {
      try {
        T user = parser(json.decode(value));
        userSubject.add(user);
      } catch (error) {
        /**
         * Could not parse data
         */
        userSubject.add(null);
      }
    }
    if (getUserFromServer != null) {
      try {
        var _user = await getUserFromServer!(currentUser);
        if (_user != null) {
          save(_user);
        }
      } catch (error) {
        print("Error = $error");
        if (error is DioError) {
          if (error.response?.statusCode == 403) {
            remove();
          }
        }
      }
    }
  }

  add(AuthStatus status, [bool force = false]) {
    if (force) {
      subject.add(status);
    } else if (subject.valueOrNull != status) {
      subject.add(status);
    }
  }

  bool get isLoggedIn {
    return subject.value == AuthStatus.logged_in;
  }

  save(T? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, json.encode(serializer(user)));
      userSubject.add(user);
    }
  }

  Future remove() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    userSubject.add(null);
  }

  T? get currentUser => userSubject.valueOrNull;

  void close() {
    _subscription.cancel();
    subject.close();
    userSubject.close();
  }
}
