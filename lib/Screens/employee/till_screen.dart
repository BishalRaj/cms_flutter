import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shakyab/Screens/components/maps_currentLocation_Screen.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/modle/ProductModle.dart';
import 'package:shakyab/services/itemsHelper.dart';
import 'package:shakyab/services/sharedPreference.dart';

class TillScreen extends StatefulWidget {
  const TillScreen({Key? key}) : super(key: key);

  @override
  State<TillScreen> createState() => _TillScreenState();
}

class _TillScreenState extends State<TillScreen> {
  SharedPreferenceHelper prefHelper = SharedPreferenceHelper();
  List<ProductModle> _productList = [];
  final _editingContoller = TextEditingController();
  double _totalValue = 0;
  Position? location;
  bool _isButtonLoading = false;
  // _TillScreenState() {
  //   _productList.add(ProductModle.withoutBarcode('Arduino', 100.0, 800.0, 5,
  //       'https://upload.wikimedia.org/wikipedia/commons/3/38/Arduino_Uno_-_R3.jpg'));
  //   _productList.add(ProductModle.withoutBarcode('Arduino', 100.0, 800.0, 5,
  //       'https://upload.wikimedia.org/wikipedia/commons/3/38/Arduino_Uno_-_R3.jpg'));
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Center(
      child: SizedBox(
        width: size.width < 426.0
            ? double.infinity
            : size.width < 769.0
                ? size.width * 0.8
                : size.width * 0.4,
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                elevation: 10,
                color: colorThree,
                shadowColor: colorThree,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _editingContoller,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusColor: Colors.black,
                                  fillColor: whiteColor,
                                  suffixIconColor: whiteColor,
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: colorOne)),
                                  prefixIcon: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  labelText: 'Barcode Number'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'^[0-9]+$').hasMatch(value) ||
                                    value.length < 3) {
                                  return "Enter valid barcode";
                                } else {
                                  return null;
                                }
                              },
                              onFieldSubmitted: (value) {
                                _onFieldSubmitted(value);
                                _editingContoller.clear();
                              },
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ListView.builder(
                  itemCount: _productList.length,
                  itemBuilder: (context, int index) =>
                      _buildItemsCard(context, index),
                ),
              ),
            ),
            _productList.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                        onPressed: () => _checkout(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: _isButtonLoading
                              ? const SpinKitCircle(
                                  color: Colors.white,
                                  size: 20.0,
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text('Checkout'),
                                    Text('Total: £ $_totalValue')
                                  ],
                                ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    ));
  }

  Widget _buildItemsCard(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final double _cardHeight = size.width * 0.3;
    final _items = _productList[index];

    const TextStyle _priceTextStyle = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: colorThree,
        fontFamily: 'Dosis');
    const TextStyle _itemPrefixStyle = TextStyle(
        fontFamily: 'Dosis',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black45);

    return Container(
      height: _cardHeight,
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 2.0),
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.network(_items.imageURL),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Text(
                    _items.productName,
                    style: const TextStyle(
                      color: colorThree,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Dosis',
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      " £ ",
                      style: _itemPrefixStyle,
                    ),
                    Text(
                      (_items.retailPrice).toString(),
                      style: _priceTextStyle,
                    )
                  ],
                ),
                const SizedBox(
                  width: 10.0,
                ),
              ],
            ),
          )),
    );
  }

  void _onFieldSubmitted(String value) async {
    ItemsHelper itemsHelper = ItemsHelper('$baseURL/items/single/$value');
    var items = await itemsHelper.getItemDataByBarcode();
    if (items.runtimeType == int) return;

    List<ProductModle> dataList = _productList;
    dataList.add(ProductModle.withBarcode(
        items['barcode'],
        items['productName'],
        items['wholesalePrice'],
        items['retailPrice'],
        items['quantity'],
        items['imageURL']));

    setState(() {
      _productList = dataList;
      _totalValue = _totalValue + items['retailPrice'] * 1.0;
    });
  }

  _checkout() async {
    setState(() {
      _isButtonLoading = true;
    });

    var location = await getCurrentLocation();
    if (location == null) {
      setState(() {
        _isButtonLoading = false;
      });
      return;
    } else {
      ItemsHelper itemsHelper = ItemsHelper('$baseURL/items/checkout');
      var loginStatus = await prefHelper.fetchLoginDetails();

      List data = [];
      for (var item in _productList) {
        data.add({
          'barcode': item.barCode,
          'quantity': item.quantity,
          'branch': loginStatus['branch'],
          'location': location
        });
      }

      print(data);

      var response = await itemsHelper.checkout(data);
      if (response == 200) {
        setState(() {
          _productList = [];
          _totalValue = 0;
          _isButtonLoading = false;
        });
      }
    }
    setState(() {
      _isButtonLoading = false;
    });
  }

  dynamic getCurrentLocation() async {
    CurrentPosition position = CurrentPosition();
    var currentLocation = await position.fetchPosition();
    return currentLocation;

    // var data = {
    //   'currentLocation': currentLocation,
    //   'branch': loginStatus['branch']
    // };
    // return data;
  }
}
