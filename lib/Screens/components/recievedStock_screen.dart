import 'package:flutter/material.dart';
import 'package:shakyab/Screens/admin/home_screen.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/modle/ProductModle.dart';
import 'package:shakyab/services/itemsHelper.dart';

class ReceivedStockScreen extends StatefulWidget {
  const ReceivedStockScreen({Key? key}) : super(key: key);

  @override
  State<ReceivedStockScreen> createState() => _ReceivedStockScreenState();
}

class _ReceivedStockScreenState extends State<ReceivedStockScreen> {
  List<ProductModle> _orderedProductList = [];

  _ReceivedStockScreenState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
          },
        ),
        backgroundColor: colorThree,
      ),
      body: SafeArea(
        child: _orderedProductList.isNotEmpty
            ? Center(
                child: SizedBox(
                  width: size.width < 426.0
                      ? double.infinity
                      : size.width < 769.0
                          ? size.width * 0.8
                          : size.width * 0.4,
                  child: ListView.builder(
                    itemCount: _orderedProductList.length,
                    itemBuilder: (context, int index) =>
                        _buildItemsCard(context, index),
                  ),
                ),
              )
            : SizedBox(
                height: 500,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('No pending orders'),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    final double _cardHeight = size.width * 0.4;
    final _items = _orderedProductList[index];

    const TextStyle _priceTextStyle = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colorThree,
        fontFamily: 'Dosis');
    const TextStyle _itemPrefixStyle = TextStyle(
        fontFamily: 'Dosis',
        fontSize: 16,
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
          child: Row(
            children: [
              Container(
                width: 75.0,
                padding: const EdgeInsets.all(5.0),
                child: Image.network(_items.imageURL),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _items.productName,
                        style: const TextStyle(
                          color: colorThree,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Dosis',
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Ordered : ",
                            style: _itemPrefixStyle,
                          ),
                          Text(
                            (_items.quantity).toString(),
                            style: _priceTextStyle,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                  child: ElevatedButton(
                      onPressed: () => _orderButtonClicked(_items, index),
                      child: const Text(
                        'Received',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {
    ItemsHelper itemsHelper = ItemsHelper('$baseURL/orders');
    var itemsData = await itemsHelper.getOrdersData();
    List<ProductModle> dataList = [];

    for (var i = 0; i < itemsData.length; i++) {
      dataList.add(ProductModle.orders(
          itemsData[i]['barcode'],
          itemsData[i]['productName'],
          itemsData[i]['quantity'],
          itemsData[i]['imageURL']));
    }

    setState(() {
      _orderedProductList = dataList;
    });
  }

  _orderButtonClicked(var items, var index) async {
    ItemsHelper itemsHelper = ItemsHelper('$baseURL/orders/confirm');

    var orderData =
        await itemsHelper.confirmOrders(items.barCode, items.quantity);

    if (orderData != null) {
      _orderedProductList.removeAt(index);
    }

    setState(() {
      _orderedProductList = _orderedProductList;
    });
  }
}
