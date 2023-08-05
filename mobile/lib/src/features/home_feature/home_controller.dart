import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile/src/features/auth_feature/auth_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController with StateMixin {
  late AuthController authController;
  late GoogleMapController mapController;
  late LatLng coordinates;
  late Position location;
  @override
  void onInit() {
    authController = Get.find<AuthController>();
    super.onInit();
  }

  @override
  void onReady() async {
    location = await determinePosition();
    coordinates = await searchForRecyclingPlants();
    super.onReady();
  }

  RxInt currentIndex = 0.obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  Future<LatLng> searchForRecyclingPlants() async {
    final argLat = location.latitude;
    final argLong = location.longitude;
    final response = await http.post(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=RecyclingPlant&location=$argLat%2C$argLong&radius=1500&key=AIzaSyBKHSgm_sa99Nu8E93peWt_KHTYxgXeLRg'),
        body: {});
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    // debugPrint(decodedResponse as String?);
    final lat = decodedResponse['results'][0]['geometry']['location']['lat'];
    final long = decodedResponse['results'][0]['geometry']['location']['lng'];
    final coordinate = LatLng(lat, long);
    return coordinate;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
