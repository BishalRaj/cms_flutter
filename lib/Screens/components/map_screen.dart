import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shakyab/Screens/components/view_trackingData.dart';
import 'package:shakyab/constants/url.dart';
import 'package:shakyab/services/itemsHelper.dart';
import 'package:shakyab/services/sharedPreference.dart';
import 'package:shakyab/route/authRoute.dart' as auth_route;

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  SharedPreferenceHelper prefHelper = SharedPreferenceHelper();
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  var _branch;
  List _locationData = [];

  // @override
  // void initState() {
  //   super.initState();
  //   _checkIfLoggedIn();
  // }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(52.408054, -1.510556),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: _onMapCreated,
        markers: _markers,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    // _controller.complete(controller);
    // 52.41618973744806, -1.5120664839301028
    await _checkIfLoggedIn();

    for (var i = 0; i < _locationData.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(
              _locationData[i]['latitude'], _locationData[i]['longitude']),
          infoWindow: InfoWindow(
            title: 'sales from ${_locationData[i]['branch']}',
            // snippet: 'We are in Coventry University'
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TrackingData(_locationData[i]['branch'])));
            },
          ),
        ),
      );
    }

    // for (var item in _locationData) {
    // _markers.add(
    //   Marker(
    //     markerId: MarkerId(item['_id']),
    //     position: LatLng(item['latitude'], item['longitude']),
    //     infoWindow: InfoWindow(
    //       title: 'sales from ${item['branch']}',
    //       // snippet: 'We are in Coventry University'
    //       onTap: () {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => TrackingData(item['branch'])));
    //       },
    //     ),
    //   ),
    // );
    // }

    setState(() {
      _markers = _markers;
    });
  }

  _checkIfLoggedIn() async {
    var loginStatus = await prefHelper.fetchLoginDetails();
    var _userType = loginStatus['userType'];
    List locationData;
    if (_userType == 'admin') {
      ItemsHelper itemsHelper = ItemsHelper('$baseURL/sales');
      locationData = await itemsHelper.getAllLocationData();
    } else {
      ItemsHelper itemsHelper =
          ItemsHelper('$baseURL/sales/${loginStatus['branch']}');
      locationData = await itemsHelper.getLocationByBranch();
    }

    setState(() {
      _branch = loginStatus['branch'];
      _locationData = locationData;
    });
  }
}
