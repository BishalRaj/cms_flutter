import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final String url;

  NetworkHelper(this.url);
  var getHeaders = {
    'Access-Control-Allow-Origin': '*', // Required for CORS support to work
    'Access-Control-Allow-Credentials':
        'true', // Required for cookies, authorizatigetHn headers with HTTPS
    'Access-Control-Allow-Headers':
        'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
    'Access-Control-Allow-Methods': 'GET, HEAD'
  };
  var postHeaders = {
    'Access-Control-Allow-Origin': '*', // Required for CORS support to work
    'Access-Control-Allow-Credentials':
        'true', // Required for cookies, authorizatigetHn headers with HTTPS
    'Access-Control-Allow-Headers':
        'Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale',
    'Access-Control-Allow-Methods': 'POST, OPTIONS'
  };

  Future login(String username, String password) async {
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
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);

      // return response;
    }
  }

  Future signup(
      String fullname, String username, String pwd, DateTime? dob) async {
    var data = {
      'fullname': fullname,
      'username': username,
      'password': pwd,
      'dob': dob.toString()
    };
    var body = jsonEncode(data);
    http.Response response = await http.post(Uri.parse(url), body: body);
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedValue = jsonDecode(data);
      return decodedValue;
    } else if (response.statusCode == 404) {
      print('code : ${response.body}');
      print(response.body);
      return response.statusCode;
    }
  }
}
