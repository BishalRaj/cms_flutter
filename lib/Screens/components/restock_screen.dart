import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/modle/ProductModle.dart';
import 'package:shakyab/services/itemsHelper.dart';

class RestockScreen extends StatefulWidget {
  const RestockScreen({Key? key}) : super(key: key);

  @override
  State<RestockScreen> createState() => _RestockScreenState();
}

class _RestockScreenState extends State<RestockScreen> {
  List<ProductModle> _flaggedProductList = [];
  List<double> _sliderValues = [];
  bool _isLoading = true;
  bool _isButtonLoading = false;

  _RestockScreenState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restock Items'),
        backgroundColor: colorThree,
      ),
      body: SafeArea(
        child: _flaggedProductList.isNotEmpty
            ? Center(
                child: SizedBox(
                  width: size.width < 426.0
                      ? double.infinity
                      : size.width < 769.0
                          ? size.width * 0.8
                          : size.width * 0.4,
                  child: ListView.builder(
                    itemCount: _flaggedProductList.length,
                    itemBuilder: (context, int index) =>
                        _buildItemsCard(context, index),
                  ),
                ),
              )
            : _isLoading
                ? const Expanded(
                    child: SpinKitCircle(size: 50, color: colorThree))
                : SizedBox(
                    height: 500,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('No flagged items'),
                        SizedBox(
                          height: 10,
                        ),
                        Text(' or '),
                        SizedBox(
                          height: 10,
                        ),
                        Text('orders are already placed')
                      ],
                    ),
                  ),
      ),
    );
  }

  void _changeSliderValue(int index, double value) {
    setState(() {
      _sliderValues[index] = value;
    });
  }

  Widget _buildItemsCard(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    // final double _cardHeight = size.width * 0.5;
    final _items = _flaggedProductList[index];

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
      // height: _cardHeight,
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 2.0),
      child: Card(
        color: Colors.white,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Text(
                    _items.productName,
                    style: const TextStyle(
                      color: colorThree,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Dosis',
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.25,
                      padding: const EdgeInsets.all(5.0),
                      child: Image.network(_items.imageURL),
                      height: 75.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Wholesale: £ ",
                                  style: _itemPrefixStyle,
                                ),
                                Text(
                                  (_items.wholesalePrice).toString(),
                                  style: _priceTextStyle,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    child: Row(
                                  children: [
                                    const Text(
                                      "Retail: £ ",
                                      style: _itemPrefixStyle,
                                    ),
                                    Text(
                                      (_items.retailPrice).toString(),
                                      style: _priceTextStyle,
                                    )
                                  ],
                                )),
                                Row(
                                  children: [
                                    const Text(
                                      "Order:  ",
                                      style: _itemPrefixStyle,
                                    ),
                                    Text(
                                      (_sliderValues[index].toInt()).toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: colorThree,
                                          fontFamily: 'Dosis'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              child: Row(
                                children: [
                                  const Text(
                                    "Remaining :  ",
                                    style: _itemPrefixStyle,
                                  ),
                                  Text(
                                    (_items.quantity).toString(),
                                    style: _priceTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _sliderValues[index].toDouble(),
                        max: 100,
                        onChanged: (double value) {
                          _changeSliderValue(index, value);
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _orderButtonClicked(_items, index),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ))
              ],
            )),
      ),
    );
  }

  void getData() async {
    ItemsHelper itemsHelper = ItemsHelper('$baseURL/items/flagged');
    var itemsData = await itemsHelper.getItemsData();

    if (itemsData.runtimeType == int || itemsData == 404) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    int totalItems = itemsData.length;
    List<ProductModle> dataList = [];
    List<double> sliderValueList = [];
    for (var i = 0; i < totalItems; i++) {
      dataList.add(ProductModle.withBarcode(
          itemsData[i]['barcode'],
          itemsData[i]['productName'],
          itemsData[i]['wholesalePrice'] * 1.0,
          itemsData[i]['retailPrice'] * 1.0,
          itemsData[i]['quantity'],
          itemsData[i]['imageURL']));

      sliderValueList.add(itemsData[i]['quantity'] * 1.0);
    }

    setState(() {
      _flaggedProductList = dataList;
      _sliderValues = sliderValueList;
      _isLoading = false;
    });
  }

  _orderButtonClicked(var items, var index) async {
    setState(() {
      _isButtonLoading = true;
    });

    ItemsHelper itemsHelper = ItemsHelper('$baseURL/orders/add');
    var orderData =
        await itemsHelper.addOrder(items.barCode, _sliderValues[index].toInt());

    if (orderData != null) {
      _flaggedProductList.removeAt(index);
    }
    setState(() {
      _flaggedProductList = _flaggedProductList;
      _isButtonLoading = false;
    });
  }
}
