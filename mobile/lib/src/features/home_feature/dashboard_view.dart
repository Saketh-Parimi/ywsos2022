import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/src/core/constants.dart';
import 'package:mobile/src/core/widgets/custom_app_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/src/features/home_feature/home_controller.dart';
import 'package:mobile/src/features/home_feature/nearest_plants_view.dart';

import '../../core/widgets/custom_drawer.dart';

class DashboardView extends GetView<HomeController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: CustomAppBar(
        title: '',
        isLoggedIn: true,
      ),
      extendBodyBehindAppBar: true,
      body: Center(
          child: Column(
        children: [
          Text('data'),
        ],
      )),
    );
  }
}
