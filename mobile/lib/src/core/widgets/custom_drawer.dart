import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/src/features/home_feature/posts/posts_view.dart';

import '../../features/home_feature/dashboard_view.dart';
import '../../features/home_feature/nearest_plants_view.dart';
import '../constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kBackgroundColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Trash Swap',
                style: Get.textTheme.headlineLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Divider(
            color: kButtonColor,
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  Icons.dashboard_outlined,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Dashboard",
                  style: Get.textTheme.bodyLarge!.copyWith(
                    color: kButtonColor,
                  ),
                ),
              ],
            ),
            onTap: () => Get.off(() => const DashboardView()),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: kButtonColor,
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.map),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Nearest Plants",
                  style:
                      Get.textTheme.titleSmall!.copyWith(color: kButtonColor),
                ),
              ],
            ),
            onTap: () => Get.off(() => NearestPlantView()),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.post_add),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Posts",
                  style:
                      Get.textTheme.titleSmall!.copyWith(color: kButtonColor),
                ),
              ],
            ),
            onTap: () => Get.off(() => const PostsView()),
          ),
        ],
      ),
    );
  }
}
