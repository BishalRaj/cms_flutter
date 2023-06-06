import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/navIcons.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/route/authRoute.dart' as authRoute;
import 'package:shakyab/services/authHelper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? _fullname;
  String? _username;
  String? _pwd;
  String? _confirmpwd;
  String _dropdownValue = 'Select your nearest branch';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool _isConfirmPwdObscure = true;
  bool _isPasswordTyped = false;
  bool _isConfirmPasswordTyped = false;
  bool _isLoading = false;

  DateTime? selectedDate;
  String getStringDate() {
    if (selectedDate == null) {
      return 'Date of Birth';
    } else {
      return '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}';
    }
  }

  DateTime? getDate() {
    if (selectedDate == null) {
      return null;
    } else {
      return selectedDate;
    }
  }

  Future pickDate(BuildContext context) async {
    final _initialDate = DateTime.now();
    final _firstDate = DateTime(DateTime.now().year - 150);
    final _lastDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: _firstDate,
        lastDate: _lastDate);
    if (newDate == null) return;

    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: colorThree,
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
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
                                  "Signup",
                                  style: TextStyle(
                                      fontFamily: 'Dosis',
                                      fontSize: 30.0,
                                      color: colorOne,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Card(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.abc,
                                          size: 20.0,
                                        ),
                                        border: UnderlineInputBorder(),
                                        labelText: 'Full Name'),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r'^[a-z A-Z]+$')
                                              .hasMatch(value) ||
                                          value.length < 3) {
                                        return "Enter valid name";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (text) => {_fullname = text},
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),

                                // Username Card

                                Card(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          size: 20.0,
                                        ),
                                        border: UnderlineInputBorder(),
                                        labelText: 'Username'),
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
                                    onSaved: (text) => {_username = text},
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),

                                // Password Card
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
                                    onSaved: (text) => {_pwd = text},
                                  ),
                                ),

                                const SizedBox(
                                  height: 15.0,
                                ),

                                //  Confirm Password Card
                                Card(
                                  child: TextFormField(
                                    obscureText: _isConfirmPwdObscure,
                                    onChanged: (text) {
                                      text.isNotEmpty
                                          ? setState(() {
                                              _isConfirmPasswordTyped = true;
                                            })
                                          : setState(() {
                                              _isConfirmPasswordTyped = false;
                                            });
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 20.0,
                                        ),
                                        border: const UnderlineInputBorder(),
                                        labelText: 'Confirm Password',
                                        suffixIcon: _isConfirmPasswordTyped
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _isConfirmPwdObscure =
                                                        !_isConfirmPwdObscure;
                                                  });
                                                },
                                                icon: Icon(_isConfirmPwdObscure
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
                                    onSaved: (text) => {_confirmpwd = text},
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),

                                //  Date of Birth
                                SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shadowColor: colorOne,
                                              primary: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0.0,
                                                      horizontal: 0.0)),
                                          onPressed: () {
                                            pickDate(context);
                                          },
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.calendar_month,
                                              size: 20.0,
                                            ),
                                            title: Text(
                                              getStringDate(),
                                              style: TextStyle(
                                                  color: selectedDate != null
                                                      ? Colors.black
                                                      : Colors.black54),
                                            ),
                                          )),
                                    )),

                                const SizedBox(
                                  height: 15.0,
                                ),

                                SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                      child: ListTile(
                                    leading: const Icon(iconHome),
                                    title: DropdownButton<String>(
                                      value: _dropdownValue,
                                      // icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: Colors.black54),

                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _dropdownValue = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'Select your nearest branch',
                                        'branch1',
                                        'branch2',
                                        'branch3'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                // Signup button
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shadowColor: colorOne,
                                            primary: colorThree,
                                            padding:
                                                const EdgeInsets.all(20.0)),
                                        onPressed: () async {
                                          try {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();

                                              setState(() {
                                                _isLoading = !_isLoading;
                                              });
                                              AuthHelper authHelper =
                                                  AuthHelper(
                                                      '$baseURL/auth/signup');

                                              var signupData =
                                                  await authHelper.signup(
                                                      _fullname,
                                                      _username,
                                                      _pwd,
                                                      getDate(),
                                                      _dropdownValue);
                                              print(
                                                  'signup data : $signupData');

                                              Navigator.pushNamed(
                                                  context, authRoute.loginPage);
                                            }
                                          } catch (e) {
                                            print(e);
                                          }
                                        },
                                        child: _isLoading
                                            ? const SpinKitCircle(
                                                color: Colors.white,
                                                size: 20.0,
                                              )
                                            : const Text(
                                                'Signup',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )))
                              ],
                            )),
                      )),
                ),
                SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Already a user ?',
                            style: TextStyle(color: colorSix),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          TextButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, authRoute.loginPage),
                              child: const Text(
                                'Login',
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
        ));
  }
}
