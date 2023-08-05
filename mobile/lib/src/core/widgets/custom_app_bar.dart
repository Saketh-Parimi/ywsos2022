import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/src/core/settings/settings_view.dart';

import '../../features/auth_feature/auth_view.dart';
import '../constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLoggedIn;

  const CustomAppBar({super.key, required this.title, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text('$title'),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Get.to(() => const ThemeView());
            },
            icon: const Icon(Icons.settings)),
        isLoggedIn
            ? IconButton(
                onPressed: () async {
                  await secureStorage.delete(key: 'access-token');
                  await secureStorage.delete(key: 'refresh-token');
                  Get.off(() => const LoginView());
                },
                icon: const Icon(Icons.logout))
            : Container(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Get.height / 10);
}
