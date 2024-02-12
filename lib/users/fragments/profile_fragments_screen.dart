import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/authentication/login_screen.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';
import 'package:shop_app/users/userPreferences/user_preferences.dart';

class ProfileFragments extends StatelessWidget {
  final _currentUser = Get.put(CurrentUser());

  SignOutUser() async {
    var resultResponse = await Get.dialog(AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        "Logout",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text("Are you sure? \n you want to log out from app?"),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "No",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: () {
              Get.back(result: "LoggedOut");
            },
            child: Text(
              "Yes",
              style: TextStyle(color: Colors.black),
            )),
      ],
    ));
    if (resultResponse == "LoggedOut") {
      RememberUser.deleteUserInfo().then((value) {
        Get.off(LoginScreen());
      });
    }
  }

  /* Widget userInfoProfile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(
            width: 16,
          ),
          Text(
            userData,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
 */
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Image.asset(
            "images/woman.png",
            width: 240,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "Hi, ${_currentUser.user.user_name}!",
            style: const TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            "email: ${_currentUser.user.user_email}",
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w200),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Material(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () {
                SignOutUser();
              },
              borderRadius: BorderRadius.circular(32),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
