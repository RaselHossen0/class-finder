import 'package:class_rasel/Global.dart';
import 'package:class_rasel/screen/chat/chat_history_screen.dart';
import 'package:class_rasel/screen/class/class_details.dart';
import 'package:class_rasel/screen/event/eventScreen.dart';
import 'package:class_rasel/screen/home.dart';
import 'package:class_rasel/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ClassDetailsScreen(),
    ChatHistoryScreen(),
    EventsScreen(),
    ClassOwnerDetailsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              haptic: true, // Haptic feedback
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(
                color: cPrimaryColor,
                width: 1,
              ), // Adds border to active tab
              tabBackgroundColor: cPrimaryColor
                  .withOpacity(0.1), // Background color of active tab
              tabMargin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              gap: 8,
              activeColor: cPrimaryColor,
              iconSize: 24,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              duration: const Duration(milliseconds: 400), // Animation duration
              curve: Curves.easeInOut, // Animation curve
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  iconColor: Colors.grey,
                  iconActiveColor: cPrimaryColor,
                ),
                GButton(
                  icon: Icons.message,
                  text: 'Messages',
                  iconColor: Colors.grey,
                  iconActiveColor: cPrimaryColor,
                ),
                GButton(
                  icon: Icons.event,
                  text: 'Events',
                  iconColor: Colors.grey,
                  iconActiveColor: cPrimaryColor,
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                  iconColor: Colors.grey,
                  iconActiveColor: cPrimaryColor,
                ),
              ],
              selectedIndex: _currentIndex,
              onTabChange: _onTabTapped,
            ),
          ),
        ),
      ),
    );
  }
}
