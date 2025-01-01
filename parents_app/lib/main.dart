import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:class_finder/profile/themes.dart';
import 'package:class_finder/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(child: MyApp()));
}

class CookingClass {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final VoidCallback onJoinTap;

  CookingClass({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.onJoinTap,
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeProvider(
      initTheme: MyThemes.lightTheme,
      child: MaterialApp(
        title: 'Parents App',
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        theme: MyThemes.lightTheme,
        // theme: ThemeProvider.of(context),
        home: const InitialScreen(),
      ),
    );
  }
}

final selectedIndexProvider = StateProvider<int>((ref) => 0);
