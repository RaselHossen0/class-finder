import 'package:class_rasel/screen/change_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:class_rasel/screen/home.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _settingsOption(
              context,
              title: "Update Profile",
              icon: Icons.person,
              onTap: () => Get.to(() => HomePage(showUpdateOption: true,)),
            ),
            const Divider(height: 1),
            _settingsOption(
              context,
              title: "Change Password",
              icon: Icons.lock,
              onTap: () => Get.to(() => SendOtpPage()),
            ),
            const Divider(height: 1),
            _settingsOption(
              context,
              title: "Change Email",
              icon: Icons.email,
              onTap: () => Get.to(() => ChangeEmailPage()),
            ),
            const Divider(height: 1),
            _settingsOption(
              context,
              title: "Log Out",
              icon: Icons.logout,
              onTap: () => _showLogoutConfirmation(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsOption(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : Colors.black,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log Out"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final box = GetStorage();
              box.write("token", "");
              Get.offAllNamed('/LogIn');
            },
            child: Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final bool showUpdateOption;

  const ProfilePage({Key? key, this.showUpdateOption = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Center(
        child: Text("Profile Update Page", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Current Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "New Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle password change logic
              },
              child: Text("Change Password"),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Current Email",
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: "New Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle email change logic
              },
              child: Text("Change Email"),
            ),
          ],
        ),
      ),
    );
  }
}