import 'dart:convert';
import 'dart:developer';

import 'package:get/get_connect.dart';
import 'package:mobile/src/core/constants.dart';
import 'package:mobile/src/models/user.dart';

class AuthService extends GetConnect {
  Future<User> loginUser(String username, String password) async {
    final response = await post(
        'http://127.0.0.1:8000/api/auth/login',
        contentType: 'application/json',
        jsonEncode({
          "username": username,
          "password": password,
        }));
    final decodedResponse = Map<String, dynamic>.from(response.body);
    if (response.statusCode != 200) {
      final String? content = decodedResponse['content'];
      print(content);
      if (content != null) {
        print(content.toString());
        throw content.toString();
      }
      throw 'An Error Occured';
    }
    final extractedData = Map<String, dynamic>.from(response.body);
    await secureStorage.write(
        key: 'access_token', value: extractedData['access_token']);
    await secureStorage.write(
        key: 'refresh_token', value: extractedData['refresh_token']);
    final user = User(username: username, password: password);
    return user;
  }

  Future<User> registerUser(String username, String password) async {
    final response = await post(
        'http://127.0.0.1:8000/api/auth/register',
        contentType: 'application/json',
        jsonEncode({
          "username": username,
          "password": password,
        }));
    final decodedResponse = Map<String, dynamic>.from(response.body);
    if (response.statusCode != 200) {
      final String? content = decodedResponse['content'];
      print(content);
      if (content != null) {
        print(content.toString());
        throw content.toString();
      }
      throw 'An Error Occured';
    }
    final user = User(username: username, password: password);
    return user;
  }

  Future<bool> verifyAccessToken() async {
    try {
      final String? accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken == null) return false;
      final response = await get(
        'http://127.0.0.1:8000/api/auth/access-token',
        headers: {
          "authorization": accessToken,
        },
      );
      if (response.statusCode != 200) {
        throw response.statusText.toString();
      }
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> refreshAccessToken() async {
    try {
      final refreshToken = await secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) return false;
      final response =
          await get('http://127.0.0.1:8000/api/auth/refresh-token', headers: {
        "authorization": "$refreshToken",
      });
      if (response.statusCode != 200) {
        throw response.statusText.toString();
      }
      final decodedResponse = Map<String, dynamic>.from(response.body);
      await secureStorage.write(
          key: 'access_token', value: decodedResponse['access_token']);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
