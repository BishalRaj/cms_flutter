import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shakyab/constants/colors.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/services/itemsHelper.dart';

class TrackingData extends StatefulWidget {
  final String? branch;
  const TrackingData(this.branch, {Key? key}) : super(key: key);

  @override
  State<TrackingData> createState() => _TrackingDataState();
}

class _TrackingDataState extends State<TrackingData> {
  @override
  void initState() {
    // TODO: implement initState
    fetchTrackingData();
    super.initState();
  }

  List trackingDataList = [];
  List trackingDataLocation = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Tracking Data'),
        backgroundColor: colorThree,
      ),
      body: ListView.builder(
        itemCount: trackingDataList.length,
        itemBuilder: (context, int index) => _buildItemsCard(context, index),
      ),
    );
  }

  Widget _buildItemsCard(BuildContext context, int index) {
    const TextStyle _priceTextStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: colorThree,
      // fontFamily: 'Dosis'
    );
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
                child: Image.network(trackingDataList[index]['imageURL']),
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
                          trackingDataList[index]['productName'],
                          style: const TextStyle(
                            color: colorThree,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            // fontFamily: 'Dosis',
                          ),
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
                                  (trackingDataList[index]['retailPrice'])
                                      .toString(),
                                  style: _priceTextStyle,
                                )
                              ],
                            )),
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  (trackingDataList[index]['quantity'])
                                      .toString(),
                                  style: _priceTextStyle,
                                ),
                                const Text(
                                  " sold",
                                  style: _itemPrefixStyle,
                                )
                              ],
                            ))
                          ],
                        ),
                        Wrap(
                          children: [
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      color: colorThree,
                                    ),
                                    Text(
                                      ' ${trackingDataLocation[index].toString().replaceAll("{", "").replaceAll("}", "")} ',
                                      style: _itemPrefixStyle,
                                    ),
                                  ],
                                )),
                            // Text(
                            //   (location).toString(),
                            //   style: _priceTextStyle,
                            // )
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  fetchTrackingData() async {
    ItemsHelper itemsHelper = ItemsHelper('$baseURL/sales/${widget.branch}');
    var response = await itemsHelper.getItemDataByBarcode();
    var location = [];
    for (var item in response) {
      var _location =
          await getLocationName(item['latitude'], item['longitude']);
      var street = _location[0];
      // print('location ${street}');

      var encode = jsonEncode(street);
      var decode = jsonDecode(encode);

      location.add({
        '${decode['street']}, ${decode['postalCode']}, ${decode['country']}'
      });
    }
    setState(() {
      trackingDataList = response;
      trackingDataLocation = location;
    });
  }

  getLocationName(double lat, double lon) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    return placemarks;
  }
}
