import 'package:class_rasel/componants/buttomNavBar.dart';
import 'package:class_rasel/screen/splash.dart';
import 'package:class_rasel/signup/second_page_for_owner.dart';
import 'package:class_rasel/signup/signup.dart';
import 'package:class_rasel/signup/th_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'every class/get_controller.dart';

Future<void> main() async {
  await GetStorage.init();
  Get.put(cont());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/Loader', page: ()=> BottomNavBar()),
        GetPage(name: '/SignUp', page: ()=>Signup()),
        GetPage(name: '/SecondSignUp', page: ()=> SecondPageForOwner()),
        GetPage(name: '/thirdSignUp', page: ()=> ThPage()),

      ],
      builder: EasyLoading.init(), // Initialize EasyLoading
    );
  }
}
