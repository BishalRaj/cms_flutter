import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shakyab/Screens/components/recievedStock_screen.dart';
import 'package:shakyab/Screens/components/restock_screen.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/modle/ProductModle.dart';
import 'package:shakyab/services/itemsHelper.dart';
import 'package:shakyab/services/sharedPreference.dart';

class ViewStockScreen extends StatefulWidget {
  const ViewStockScreen({Key? key}) : super(key: key);

  @override
  State<ViewStockScreen> createState() => _ViewStockScreenState();
}

class _ViewStockScreenState extends State<ViewStockScreen> {
  SharedPreferenceHelper prefHelper = SharedPreferenceHelper();
  final List<ProductModle> _productList = [];
  double _currentStockValue = 0;
  int _lowStockItem = 0;
  int _totalItem = 0;
  bool _hasData = false;
  bool _isAdmin = false;
  bool _isLoading = true;

  _ViewStockScreenState() {
    getData();
    _checkIfLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: SizedBox(
        width: size.width < 426.0
            ? double.infinity
            : size.width < 769.0
                ? size.width * 0.8
                : size.width * 0.4,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ..._buildDetailsCard(),
                ],
              ),
            ),
            _isAdmin
                ? Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                // side: const BorderSide(color: colorThree),
                                shadowColor: colorThree),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RestockScreen()));
                            },
                            child: const Text(
                              'Restock',
                              style: TextStyle(
                                  color: colorThree,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          width: 15.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: colorThree, shadowColor: colorSeven),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReceivedStockScreen()));
                            },
                            child: const Text('Received Stock'))
                      ],
                    ),
                  )
                : const SizedBox(
                    height: 10,
                  ),
            _isLoading
                ? const Expanded(
                    child: SpinKitCircle(size: 50, color: colorThree))
                : Expanded(
                    child: _hasData
                        ? ListView.builder(
                            itemCount: _productList.length,
                            itemBuilder: (context, int index) =>
                                _buildItemsCard(context, index),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [Text('Nothing to show')],
                          ),
                  )
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDetailsCard() {
    List<Widget> _flaggedCards = [];
    _flaggedCards.add(
      SizedBox(
        height: 150.0,
        width: 150.0,
        child: Card(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color.fromRGBO(36, 178, 187, 1), colorThree])),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Total Value',
                      style: TextStyle(
                          // fontFamily: 'Dosis',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white70),
                    ),
                    Text(
                      "£" + _currentStockValue.toString(),
                      style: const TextStyle(
                          // fontFamily: 'Dosis',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );

    _flaggedCards.add(
      SizedBox(
        height: 150.0,
        width: 150.0,
        child: Card(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color.fromRGBO(36, 178, 187, 1), colorThree])),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Low Stock Items',
                      style: TextStyle(
                          // fontFamily: 'Dosis',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white70),
                    ),
                    Text(
                      _lowStockItem.toString(),
                      style: const TextStyle(
                          // fontFamily: 'Dosis',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );

    _flaggedCards.add(
      SizedBox(
        height: 150.0,
        width: 150.0,
        child: Card(
          child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color.fromRGBO(36, 178, 187, 1), colorThree])),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Total Items',
                      style: TextStyle(
                          // fontFamily: 'Dosis',
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white70),
                    ),
                    Text(
                      _totalItem.toString(),
                      style: const TextStyle(
                          // fontFamily: 'Dosis',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );

    return _flaggedCards;
  }

  Widget _buildItemsCard(BuildContext context, int index) {
    final _items = _productList[index];

    const TextStyle _priceTextStyle = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: colorThree,
        fontFamily: 'Dosis');
    const TextStyle _itemPrefixStyle = TextStyle(
        // fontFamily: 'Dosis',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black45);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 2.0),
      child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Image.network(_items.imageURL),
                  width: 100.0,
                ),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _items.productName,
                            style: const TextStyle(
                              color: colorThree,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              // fontFamily: 'Dosis',
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
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
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Expanded(
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
                              Expanded(
                                  child: Row(
                                children: [
                                  Text(
                                    (_items.quantity).toString(),
                                    style: _priceTextStyle,
                                  ),
                                  const Text(
                                    " left",
                                    style: _itemPrefixStyle,
                                  )
                                ],
                              ))
                            ],
                          )
                        ],
                      )),
                ),
                if (_items.quantity <= 5)
                  GestureDetector(
                    onTap: () {
                      if (!_isAdmin) return;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RestockScreen(),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                        ),
                        Text(
                          'Low Stock',
                          style: TextStyle(
                              color: Colors.red,
                              // fontFamily: 'Dosis',
                              fontSize: 11,
                              fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  )
                else
                  const SizedBox(
                    height: 0.0,
                    width: 0.0,
                  )
              ],
            ),
          )),
    );
  }

  void getData() async {
    ItemsHelper itemsHelper = ItemsHelper('$baseURL/items');
    var itemsData = await itemsHelper.getItemsData();
    double currentStockValue = 0;
    int lowStockItem = 0;

    if (itemsData.runtimeType == int || itemsData == 404) {
      setState(() {
        _hasData = false;
        _isLoading = false;
      });
      return;
    }

    int totalItems = itemsData.length;
    for (var i = 0; i < totalItems; i++) {
      _productList.add(ProductModle.withoutBarcode(
          itemsData[i]['productName'],
          itemsData[i]['wholesalePrice'] * 1.0,
          itemsData[i]['retailPrice'] * 1.0,
          itemsData[i]['quantity'],
          itemsData[i]['imageURL']));

      currentStockValue = currentStockValue +
          _productList[i].wholesalePrice * _productList[i].quantity;

      if (_productList[i].quantity <= 5) {
        lowStockItem = lowStockItem + 1;
      }
    }

    if (this.mounted) {
      setState(() {
        _currentStockValue = currentStockValue;
        _lowStockItem = lowStockItem;
        _totalItem = totalItems;
        _hasData = true;
        _isLoading = false;
      });
    }
  }

  void _checkIfLoggedIn() async {
    var loginStatus = await prefHelper.fetchLoginDetails();

    bool isAdmin = false;
    if (loginStatus['userType'] == 'admin') isAdmin = true;

    setState(() {
      _isAdmin = isAdmin;
    });
  }
}
