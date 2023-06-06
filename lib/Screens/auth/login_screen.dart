import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/route/authRoute.dart' as route;
import 'package:shakyab/services/authHelper.dart';
import 'package:shakyab/services/sharedPreference.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SharedPreferenceHelper prefHelper = SharedPreferenceHelper();
  bool _isObscure = true;
  bool _isPasswordTyped = false;
  bool _isLoading = false;
  String? _username;
  String? _password;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: 'assets/images/logoWhite.png',
        splashIconSize: 200,
        duration: 1000,
        backgroundColor: colorThree,
        nextScreen: Scaffold(
          backgroundColor: colorThree,
          body: Center(
            child: SingleChildScrollView(
              child: SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(
                  //   height: size.height * 0.2,
                  // ),
                  SizedBox(
                    // height: size.height < 659 ? 400 : size.height * 0.55,
                    width: size.width < 426.0
                        ? double.infinity
                        : size.width < 769.0
                            ? size.width * 0.5
                            : size.width * 0.3,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      color: colorSix,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 50.0, horizontal: 20.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  const Text(
                                    'Welcome!',
                                    style: TextStyle(
                                        fontFamily: 'Dosis',
                                        fontSize: 30.0,
                                        color: colorOne,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                    'Login to continue',
                                    style: TextStyle(
                                      fontFamily: 'Dosis',
                                      fontSize: 20.0,
                                      color: colorTwo,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Card(
                                    child: TextFormField(
                                      // key: _formKey,
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            size: 20.0,
                                          ),
                                          border: UnderlineInputBorder(),
                                          labelText: 'Enter your username'),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'^[A-Za-z0-9_-]*$')
                                                .hasMatch(value) ||
                                            value.length < 3) {
                                          return "Enter valid username";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) => {_username = value},
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Card(
                                    child: TextFormField(
                                      obscureText: _isObscure,
                                      onChanged: (text) {
                                        text.isNotEmpty
                                            ? setState(() {
                                                _isPasswordTyped = true;
                                              })
                                            : setState(() {
                                                _isPasswordTyped = false;
                                              });
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            size: 20.0,
                                          ),
                                          border: const UnderlineInputBorder(),
                                          labelText: 'Password',
                                          suffixIcon: _isPasswordTyped
                                              ? IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isObscure = !_isObscure;
                                                    });
                                                  },
                                                  icon: Icon(_isObscure
                                                      ? Icons.visibility
                                                      : Icons.visibility_off))
                                              : null),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'^[A-Za-z0-9_-]*$')
                                                .hasMatch(value)) {
                                          return "Enter valid password";
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (text) => {_password = text},
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shadowColor: colorOne,
                                          primary: colorThree,
                                          padding: const EdgeInsets.all(20.0)),
                                      onPressed: () async {
                                        loginButtonPressed(
                                            _username, _password);
                                      },
                                      child: _isLoading
                                          ? const SpinKitCircle(
                                              color: Colors.white,
                                              size: 20.0,
                                            )
                                          : const Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                    ),
                                  ),
                                ],
                              ))),
                    ),
                  ),
                  SizedBox(
                    // height: size.height * 0.1,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'New user ?',
                              style: TextStyle(color: colorSix),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            TextButton(
                                onPressed: () => Navigator.pushNamed(
                                    context, route.signupPage),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                )),
                          ],
                        )),
                  )
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  void loginButtonPressed(String? username, String? password) async {
    // try {
    //   if (Platform.isAndroid) {
    //     Navigator.pop(context);
    //     Navigator.pushNamed(
    //         context, route.adminPage);
    //   }
    // } catch (e) {
    //   print(e);
    // }
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        AuthHelper authHelper = AuthHelper('$baseURL/auth/login');
        var loginData = await authHelper.login(_username, _password);
        setState(() {
          _isLoading = false;
        });
        if (loginData == null && loginData.runtimeType == int) return;

        if (loginData['userType'] == 'admin') {
          prefHelper.saveLoginDetails(
              'admin', loginData['username'], loginData['branch']);
          Navigator.pop(context);
          Navigator.pushNamed(context, route.adminPage);
        } else {
          prefHelper.saveLoginDetails(
              'user', loginData['username'], loginData['branch']);
          Navigator.pop(context);
          Navigator.pushNamed(context, route.employeePage);
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _checkIfLoggedIn() async {
    var loginStatus = await prefHelper.fetchLoginDetails();
    if (loginStatus['username'] == null) return;

    if (loginStatus['userType'] == 'admin') {
      Navigator.pop(context);
      Navigator.pushNamed(context, route.adminPage);
    }

    if (loginStatus['userType'] == 'user') {
      Navigator.pop(context);
      Navigator.pushNamed(context, route.employeePage);
    }
  }
}
