import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mobile/src/core/widgets/custom_drawer.dart';
import 'package:mobile/src/features/home_feature/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/widgets/custom_app_bar.dart';

class NearestPlantView extends GetView<HomeController> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  NearestPlantView({super.key});

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: const CustomDrawer(),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: controller.coordinates, zoom: 19.3),
        onMapCreated: _onMapCreated,
        markers: {
          Marker(
            markerId: const MarkerId("Recycling Plant1"),
            position: controller.coordinates,
            infoWindow: const InfoWindow(
              title: 'Recycling Plant',
            ),
          )
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.scaffoldKey.currentState!.openDrawer(),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: const Icon(Icons.menu, size: 30.0,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
