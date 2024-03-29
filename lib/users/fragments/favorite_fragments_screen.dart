import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';

class FavoritesFragments extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text("Favorites")),
        );
      },
    );
  }
}
