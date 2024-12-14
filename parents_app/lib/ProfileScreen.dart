import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  final VoidCallback onLogout;

  const ProfileWidget({
    Key? key,
    required this.name,
    required this.email,
    required this.imageUrl,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(12),
        // ),
        // elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(height: 12),
              Text(
                name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              Text(
                email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onLogout,
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Logout", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
