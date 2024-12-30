import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Welcome/welcome_screen.dart';
import '../Screens/nav/navigation_screen.dart';
import '../providers/locationServiceProvider.dart';
import '../providers/user_provider.dart';

class InitialScreen extends ConsumerStatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends ConsumerState<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Fetch location permissions and position
      await ref.read(locationNotifierProvider.notifier).fetchLocation();

      // Step 2: Check token and navigate accordingly
      await _checkToken();
    } catch (e) {
      // Handle location permission errors or navigation errors
      print(e);
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Replace with your token key

    if (token != null && token.isNotEmpty) {
      try {
        await ref.read(userDetailsProvider.notifier).fetchUserDetails(token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AppScreens()),
        );
      } catch (e) {
        print(e);
        await prefs.remove('token');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationNotifierProvider);

    // Show appropriate loading/error during location fetch
    return Scaffold(
      body: locationState.when(
        data: (location) {
          String city = location['city'];
          double latitude = location['latitude'];
          double longitude = location['longitude'];

          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
