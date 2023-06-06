import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;

class ItemsHelper {
  final String url;

  ItemsHelper(this.url);

  Future getItemsData() async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedValue = jsonDecode(data);
      return decodedValue;
    } else {
      return (response.statusCode);
    }
  }

  Future getFlaggedItemsData() async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedValue = jsonDecode(data);
        return decodedValue;
      } else {
        return (response.statusCode);
      }
    } catch (e) {
      if (e == "XMLHttpRequest ") {
        Fluttertoast.showToast(
            msg: 'No Internet Connection',
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5);
        print(e);
      }
    }
  }

  static Future<TaskSnapshot>? uploadImageToFIrebase(destination, _file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(_file).whenComplete(() => null);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  Future<String?> _uploadImage(File _file) async {
    final fileName = Path.basename(_file.path);
    final destination = 'files/$fileName';
    final taskSnapshot = await uploadImageToFIrebase(destination, _file);

    if (taskSnapshot == null) return null;

    final imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future addItems(int barcode, String name, double wholesale, double retail,
      int quantity, File image) async {
    var imageUrl = await _uploadImage(image);
    var data = {
      'barcode': barcode,
      'productName': name,
      'wholesalePrice': wholesale,
      'retailPrice': retail,
      'quantity': quantity,
      'imageURL': imageUrl ??
          'https://www.pngitem.com/pimgs/m/72-722791_gallery-icon-png-circle-clipart-png-download-gallery.png'
    };
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'Item added Successfully.',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);

      String data = response.body;
      var decodedValue = jsonDecode(data);
      return response.statusCode;
    } else if (response.statusCode == 404) {
      return response.statusCode;
    }
  }

  Future addOrder(int barcode, int quantity) async {
    var data = {
      'barcode': barcode,
      'quantity': quantity,
    };
    http.Response response =
        await http.post(Uri.parse(url), body: jsonEncode(data));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'Order placed',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);

      String data = response.body;
      var decodedValue = jsonDecode(data);
      return decodedValue;
    } else if (response.statusCode == 404) {
      return response.statusCode;
    }
  }

  Future getOrdersData() async {
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    var decodedValue = jsonDecode(data);
    if (response.statusCode == 200) {
      return decodedValue;
    } else {
      return response.statusCode;
    }
  }

  Future confirmOrders(int barcode, int quantity) async {
    var data = {
      'barcode': barcode,
      'quantity': quantity,
    };
    http.Response response =
        await http.put(Uri.parse(url), body: jsonEncode(data));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'Order confirmed',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);

      String data = response.body;
      var decodedValue = jsonDecode(data);
      return decodedValue;
    } else if (response.statusCode == 404) {
      return response.statusCode;
    }
  }

  Future getItemDataByBarcode() async {
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    var decodedValue = jsonDecode(data);

    if (response.statusCode == 200) {
      // Fluttertoast.showToast(
      //     msg: 'data fetched',
      //     backgroundColor: Colors.green,
      //     textColor: Colors.white,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 5);
      return decodedValue;
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(
          msg: decodedValue['message'],
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);
      return response.statusCode;
    }
  }

  Future checkout(var checkoutList) async {
    http.Response response =
        await http.put(Uri.parse(url), body: jsonEncode(checkoutList));
    String data = response.body;

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'Checked Out Successfully',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);
      return response.statusCode;
    } else if (response.statusCode == 404) {
      var decodedValue = jsonDecode(data);

      Fluttertoast.showToast(
          msg: decodedValue['message'],
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);
      return response.statusCode;
    }
  }

  Future getLocationByBranch() async {
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    var decodedValue = jsonDecode(data);

    if (response.statusCode == 200) {
      return decodedValue;
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(
          msg: decodedValue['message'],
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);
      return response.statusCode;
    }
  }

  Future getAllLocationData() async {
    http.Response response = await http.get(Uri.parse(url));
    String data = response.body;
    var decodedValue = jsonDecode(data);

    if (response.statusCode == 200) {
      return decodedValue;
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(
          msg: decodedValue['message'],
          backgroundColor: Colors.green,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5);
      return response.statusCode;
    }
  }
}
