import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../main.dart';
import '../../profile/page/profile_page.dart';
import '../event/eventScreen.dart';
import '../home/home_screen.dart';

class AppScreens extends ConsumerStatefulWidget {
  const AppScreens({super.key});

  @override
  ConsumerState<AppScreens> createState() => _AppScreensState();
}

class _AppScreensState extends ConsumerState<AppScreens> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [HomeScreen(), EventsScreen(), ProfilePage()],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.event,
                  text: 'Events',
                ),
                // GButton(
                //   icon: Icons.message,
                //   text: 'Messages',
                // ),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                ref.read(selectedIndexProvider.notifier).state = index;

                // Handle tab change
              },
            ),
          ),
        ),
      ),
    );
  }
}
