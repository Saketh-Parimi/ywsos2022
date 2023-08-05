import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile/src/core/widgets/custom_app_bar.dart';

import '../../../core/widgets/custom_drawer.dart';

class PostsView extends GetView {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'All Posts'),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Title",
                      style: Get.textTheme.titleMedium,
                    ),
                    Row(
                      children: [
                        Icon(Icons.pin_drop),
                        Text('location'),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
