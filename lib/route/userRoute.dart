import 'package:flutter/material.dart';
import 'package:shakyab/Screens/components/restock_screen.dart';

const String restockPage = 'restockPage';

Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case restockPage:
      return MaterialPageRoute(builder: (context) => const RestockScreen());

    default:
      throw ('Invalid Page');
  }
}
