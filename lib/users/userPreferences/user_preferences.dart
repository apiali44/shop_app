import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/users/model/user.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';

class RememberUser {
  //save user info locally
  static Future<void> storeUserInfo(User userInfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonData);
  }

  static Future<User?> readUser() async {
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDataMap);
    }
    return currentUserInfo;
  }

  static Future<void> deleteUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('currentUser');
  }
}
