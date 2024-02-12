import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shop_app/users/fragments/favorite_fragments_screen.dart';
import 'package:shop_app/users/fragments/home_fragments_screen.dart';
import 'package:shop_app/users/fragments/oder_fragments_screen.dart';
import 'package:shop_app/users/fragments/profile_fragments_screen.dart';
import 'package:shop_app/users/userPreferences/current_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashboardOfFragments extends StatelessWidget {
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  final List<Widget> _fragmentsScreen = [
    HomeFragments(),
    FavoritesFragments(),
    OrderFragments(),
    ProfileFragments(),
  ];

  final List _navButtonProps = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorite",
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Orders",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_outline,
      "label": "Favorite",
    },
  ];

  final RxInt _indexNumber = 0.obs;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Obx(
              () => _fragmentsScreen[_indexNumber.value],
            ),
          ),
          bottomNavigationBar: Obx(() => BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value) {
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: false,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white24,
                items: List.generate(4, (index) {
                  var navButtonProp = _navButtonProps[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.deepPurpleAccent,
                    icon: Icon(
                      navButtonProp["non_active_icon"],
                    ),
                    activeIcon: Icon(
                      navButtonProp["active_icon"],
                    ),
                    label: navButtonProp["label"],
                  );
                }),
              )),
        );
      },
    );
  }
}
