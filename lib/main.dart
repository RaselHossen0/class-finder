import 'package:class_rasel/componants/buttomNavBar.dart';
import 'package:class_rasel/screen/create_event.dart';
import 'package:class_rasel/screen/enge.dart';
import 'package:class_rasel/screen/enge/event_show.dart';
import 'package:class_rasel/screen/login/login_screen.dart';
import 'package:class_rasel/screen/splash.dart';
import 'package:class_rasel/signup/second_page_for_owner.dart';
import 'package:class_rasel/signup/signup.dart';
import 'package:class_rasel/signup/th_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'every class/get_controller.dart';
import 'iniApp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(cont()); // Ensures Flutter bindings are initialized
  await GetStorage.init(); // Initialize GetStorage
  await initializeApp(); // Call the custom initialization function
  // Register the controller
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/Loader', page: () => BottomNavBar()),
        GetPage(name: '/SignUp', page: () => Signup()),
        GetPage(name: '/LogIn', page: () => LoginScreen()),
        GetPage(
          name: '/Enge/:id',
          page: () {
            // Retrieve the id from route parameters and parse it to int
            final id = int.tryParse(Get.parameters['id'] ?? '0') ?? 0;
            return Enge(initialIndex: id);
          },
        ),
        GetPage(name: '/SecondSignUp', page: () => SecondPageForOwner()),
        GetPage(name: '/thirdSignUp', page: () => ThPage()),
        GetPage(name: '/CreateEvent', page: () => CreateEvent()),
        GetPage(name: '/EventShow', page: () => EventShow()),
      ],
      builder: EasyLoading.init(), // Initialize EasyLoading
    );
  }
}
