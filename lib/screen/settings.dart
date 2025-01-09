import 'package:class_rasel/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componants/ButtonWidget.dart';
import '../every class/get_controller.dart';

class ClassOwnerDetailsScreen extends StatelessWidget {
  // Theme colors
  final Color primaryColor = const Color(0xFF2C2C2C);
  final Color backgroundColor = Colors.white;
  final Color cardColor = Colors.white;
  final Color textPrimaryColor = const Color(0xFF2C2C2C);
  final Color textSecondaryColor = const Color(0xFF6B7280);
  final Color dividerColor = const Color(0xFFE5E7EB);
  final cont userDetails = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   elevation: 0,
      //   // title: Text(
      //   //   "Class Owner Details",
      //   //   style: TextStyle(color: textPrimaryColor),
      //   // ),
      //   forceMaterialTransparency: true,
      //   backgroundColor: backgroundColor,
      //   iconTheme: IconThemeData(color: primaryColor),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Profile Section
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(userDetails.user.profileImage),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userDetails.user.name,
                    style: TextStyle(
                      color: textPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userDetails.user.email,
                    style: TextStyle(
                      color: textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Details Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Contact Details
                  _buildSection(
                    "Contact Information",
                    [
                      if (userDetails.user.mobileNumber != null)
                        DetailTile(
                          icon: Icons.phone,
                          label: "Mobile Number",
                          value: userDetails.user.mobileNumber!,
                        ),
                      if (userDetails.user.alternateMobileNumber != null)
                        DetailTile(
                          icon: Icons.phone_android,
                          label: "Alternate Mobile",
                          value: userDetails.user.alternateMobileNumber!,
                        ),
                    ],
                  ),
                  Divider(color: dividerColor, height: 1),
                  // ID Details
                  _buildSection(
                    "Identity Details",
                    [
                      if (userDetails.user.adharCardNum != null)
                        DetailTile(
                          icon: Icons.credit_card,
                          label: "Aadhaar Number",
                          value: userDetails.user.adharCardNum!,
                        ),
                      if (userDetails.user.panCardNum != null)
                        DetailTile(
                          icon: Icons.account_balance_wallet,
                          label: "PAN Number",
                          value: userDetails.user.panCardNum!,
                        ),
                    ],
                  ),
                  Divider(color: dividerColor, height: 1),
                  // Documents
                  _buildSection(
                    "Documents",
                    [
                      if (userDetails.user.aadharCardFile != null)
                        DocumentTile(
                          icon: Icons.file_copy,
                          label: "Aadhaar Card",
                          fileName: userDetails.user.aadharCardFile!,
                        ),
                      if (userDetails.user.panCardFile != null)
                        DocumentTile(
                          icon: Icons.file_copy,
                          label: "PAN Card",
                          fileName: userDetails.user.panCardFile!,
                        ),
                      if (userDetails.user.photo != null)
                        DocumentTile(
                          icon: Icons.image,
                          label: "Photograph",
                          fileName: userDetails.user.photo!,
                        ),
                      if (userDetails.user.certificates.isNotEmpty)
                        Row(
                            children: userDetails.user.certificates
                                .map((certificate) => DocumentTile(
                                      icon: Icons.card_membership,
                                      label: "Certificates",
                                      fileName: certificate,
                                    ))
                                .toList()),
                    ],
                  ),
                ],
              ),
            ),
            Center(
                child: ButtonWidget(
              text: 'Logout',
              onClicked: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                    (route) => false);
              },
            )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textPrimaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B7280), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF2C2C2C),
                    fontSize: 16,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DocumentTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String fileName;

  const DocumentTile({
    required this.icon,
    required this.label,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6B7280), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye, color: Color(0xFF6B7280)),
            onPressed: () {
              // Add view functionality here
            },
          ),
        ],
      ),
    );
  }
}
