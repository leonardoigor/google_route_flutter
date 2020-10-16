import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission/permission.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Set<Polyline> polylini = {};
  double latitude = -20.346961;
  double longitude = -40.426947;

  GoogleMapController _controller;
  List<LatLng> routCoords;
  GoogleMapPolyline googleMapPolyline =
      new GoogleMapPolyline(apiKey: 'AIzaSyBHCwqr3ysJSkKknMoy8yV84tGMmfauXWY');

  getSomePoints() async {
    var permissions =
        await Permission.getPermissionsStatus([PermissionName.Location]);

    if (permissions[0].permissionStatus == PermissionStatus.notAgain) {
      var askpermissions =
          await Permission.requestPermissions([PermissionName.Location]);
      print(askpermissions);
    } else {
      print('alse');
      routCoords = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(latitude, longitude),
        destination: LatLng(-20.342609, -40.400081),
        mode: RouteMode.driving,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      getSomePoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        polylines: polylini,
        onMapCreated: onMapCreated,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 14.0),
        mapType: MapType.normal,
      ),
      bottomSheet: RaisedButton(
        onPressed: () => getSomePoints(),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      polylini.add(
        Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: routCoords,
          width: 4,
          color: Colors.blue,
          startCap: Cap.roundCap,
          endCap: Cap.buttCap,
        ),
      );
    });
  }
}
