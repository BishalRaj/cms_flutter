import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AuthHelper {
  final String url;

  AuthHelper(this.url);
  // var getHeaders = {
  //   'Access-Control-Allow-Origin': '*', // Required for CORS support to work
  //   'Access-Control-Allow-Credentials':
  //       'true', // Required for cookies, authorizatigetHn headers with HTTPS
  //   'Access-Control-Allow-Headers':
  //       'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
  //   'Access-Control-Allow-Methods': 'GET, HEAD'
  // };
  var postHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Credentials': 'true',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Methods': '*'
  };

  Future login(String? username, String? password) async {
    var body = jsonEncode({"username": username, "password": password});
    http.Response response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedValue = jsonDecode(data);
      return decodedValue;
    } else if (response.statusCode == 404) {
      String data = response.body;
      var decodedValue = jsonDecode(data);
      Fluttertoast.showToast(
          msg: decodedValue['message'],
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER_RIGHT,
          timeInSecForIosWeb: 5);
    } else {
      Fluttertoast.showToast(
          msg: 'No internet Connection !',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER_RIGHT,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5);
    }

    // try {} catch (e) {
    //   print(e);
    //   // Fluttertoast.showToast(
    //   //     msg: 'No internet Connection !',
    //   //     backgroundColor: Colors.red,
    //   //     textColor: Colors.white,
    //   //     gravity: ToastGravity.CENTER_RIGHT,
    //   //     toastLength: Toast.LENGTH_LONG,
    //   //     timeInSecForIosWeb: 5);
    // }
  }

  Future signup(String? fullname, String? username, String? pwd, DateTime? dob,
      String? branch) async {
    String? _branch;

    if (branch == 'Select your nearest branch') {
      _branch = 'branch1';
    } else {
      _branch = branch;
    }

    try {
      var data = {
        'fullname': fullname,
        'username': username,
        'password': pwd,
        'dob': dob.toString(),
        'branch': _branch,
        'userType': 'user'
      };

      var body = jsonEncode(data);
      http.Response response = await http.post(Uri.parse(url), body: body);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Successfully created an account.',
            backgroundColor: Colors.green,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5);

        String data = response.body;
        var decodedValue = jsonDecode(data);
        return decodedValue;
      } else if (response.statusCode == 404) {
        print('code : ${response.body}');
        return response.statusCode;
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
          msg: 'No internet Connection!',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);
    }
  }
}
