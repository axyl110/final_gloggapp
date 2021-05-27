import 'package:flutter/material.dart';
import 'package:final_gloggapp/service/authentication.dart';

class Provider extends InheritedWidget {
  final FlutterFireAuthService auth;
  Provider({
    Key key,
    Widget child,
    this.auth,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWiddget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>());
}
