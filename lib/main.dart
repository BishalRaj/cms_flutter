import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'route/authRoute.dart' as _auth_route;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (e) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCrl5j2qxphdd0espAaoIuMF45b8Jz6pTo",
          appId: "1:402016848046:web:b6fc6cfc8b8d954282853f",
          messagingSenderId: "402016848046",
          storageBucket: "pos-stock-inventory.appspot.com",
          authDomain: "pos-stock-inventory.firebaseapp.com",
          projectId: "pos-stock-inventory"),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _auth_route.controller,
      initialRoute: _auth_route.loginPage,
    );
  }
}
