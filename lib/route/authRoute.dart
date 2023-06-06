import 'package:flutter/material.dart';
import 'package:shakyab/Screens/admin/home_screen.dart' as adminhome;
import 'package:shakyab/Screens/employee/employee_home_screen.dart'
    as employeehome;

import 'package:shakyab/Screens/auth/login_screen.dart';
import 'package:shakyab/Screens/auth/signup_screen.dart';

const String loginPage = 'login';
const String signupPage = 'signup';
const String adminPage = 'adminhome';
const String employeePage = 'employeehome';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case signupPage:
      return MaterialPageRoute(builder: (context) => const SignupScreen());
    case adminPage:
      return MaterialPageRoute(
          builder: (context) => const adminhome.HomeScreen());
    case employeePage:
      return MaterialPageRoute(
          builder: (context) => const employeehome.EmployeeHomeScreen());

    default:
      throw ('Invalid Page');
  }
}
