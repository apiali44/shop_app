import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/users/authentication/login_screen.dart';
import 'package:shop_app/users/fragments/dashboard_of_fragments.dart';

import 'package:shop_app/users/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shop App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        /* colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,*/
      ),
      home: FutureBuilder(
        future: RememberUser.readUser(),
        builder: (context, dataSnapShot) {
          if (dataSnapShot.data == null) {
            return LoginScreen();
          } else {
            return DashboardOfFragments();
          }
        },
      ),
    );
  }
}
