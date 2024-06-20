import 'package:flutter/material.dart';
import 'package:shop_app/screens/my_account/my_account_screen.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';

import 'screens/init_screen.dart';
Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case "/":
      return MaterialPageRoute(builder: (_) => const InitScreen());
    case "/myAccount":
      return MaterialPageRoute(builder: (_) => const MyAccountScreen());
    case "/sign_in":
    return MaterialPageRoute(builder: (_) => const SignInScreen());
    default:
      return null; // Hoặc một route xử lý lỗi 404
  }
}
