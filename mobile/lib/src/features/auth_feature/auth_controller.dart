import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/src/core/constants.dart';
import 'package:mobile/src/features/auth_feature/auth_service.dart';
import 'package:mobile/src/features/auth_feature/auth_view.dart';
import 'package:mobile/src/features/home_feature/dashboard_view.dart';

import '../../models/user.dart';

class AuthController extends GetxController with StateMixin {
  final authService = AuthService();

  final emailTextController = TextEditingController();
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  late Rx<User> user;

  RxBool isRegister = false.obs;

  void loginUser(String username, String password) async {
    try {
      change(null, status: RxStatus.loading());
      await authService.loginUser(username, password);

      Get.off(() => DashboardView());

      print(await secureStorage.read(key: 'access_token'));
      user.value = User(username: username, password: password);
      Get.put(AuthController());
      change(null, status: RxStatus.success());
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Something Went Wrong",
        message: e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: kButtonColor,
        leftBarIndicatorColor: kErrorColor,
        duration: Duration(seconds: 2),
      ));
      change(e.toString(), status: RxStatus.error());
    }
  }

  void registerUser(String username, String password) async {
    try {
      change(null, status: RxStatus.loading());
      user.value = User(username: username, password: password);
      Get.put(AuthController());
      isRegister.toggle();
      usernameTextController.clear();
      passwordTextController.clear();
      change(null, status: RxStatus.success());
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        title: "Something Went Wrong",
        message: e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: kButtonColor,
        leftBarIndicatorColor: kErrorColor,
        duration: Duration(seconds: 2),
      ));
      change(e.toString(), status: RxStatus.error());
    }
  }

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
  }

  @override
  void onReady() async {
    super.onReady();
    final isAccessTokenVerified = await authService.verifyAccessToken();

    if (isAccessTokenVerified) {
      // change(null, status: RxStatus.success());
      Get.off(() => DashboardView());
    } else {
      final isRefreshTokenVerified = await authService.refreshAccessToken();
      if (isRefreshTokenVerified) {
        Get.off(() => DashboardView());
      }
    }
    change(null, status: RxStatus.success());
  }

  @override
  void onClose() {
    usernameTextController.dispose();
    passwordTextController.dispose();
    super.onClose();
  }
}
