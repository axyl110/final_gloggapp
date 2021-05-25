import 'package:final_gloggapp/screens/homescreen.dart';
import 'package:final_gloggapp/screens/loginscreen.dart';
import 'package:final_gloggapp/screens/signupscreen.dart';
import 'package:flutter/material.dart';


class AppRoutes {
  AppRoutes._();

  static const String authLogin = '/auth-login';
  static const String authRegister = '/auth-register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> define() {
    return {
      authLogin: (context) => LoginScreen(),
      authRegister: (context) => SignUpScreen(),
      home: (context) => HomeScreen(),
    };
  }
}
