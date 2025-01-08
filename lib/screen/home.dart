import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../every class/get_controller.dart';
import '../home_service.dart';

class HomePage extends StatefulWidget {
  final bool showUpdateOption;

  const HomePage({Key? key, this.showUpdateOption = false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>> _userData;
  final cont profileCont = Get.find();
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController alternateMobileController = TextEditingController();
  final TextEditingController aadhaarNumberController = TextEditingController();
  final TextEditingController panCardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userData = ApiService().fetchUserDetails(profileCont.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!['error'] != 0) {
            return const Center(child: Text('Failed to load profile data.'));
          }

          final data = snapshot.data!;
          final user = data['user'];
          final classOwner = data['classOwner'];

          // Populate controllers with initial data
          nameController.text = user['name'] ?? '';
          emailController.text = user['email'] ?? '';
          mobileNumberController.text = classOwner['mobileNumber'] ?? '';
          alternateMobileController.text = classOwner['alternateMobileNumber'] ?? '';
          aadhaarNumberController.text = classOwner['aadhaarCardNumber'] ?? '';
          panCardNumberController.text = classOwner['panCardNumber'] ?? '';

          return CustomScrollView(
            slivers: [
              // Collapsible AppBar with Profile Picture
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                backgroundColor: Colors.blue,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(user['name'] ?? '', style: TextStyle(fontSize: 18)),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://classroom-api.raselhossen.tech${user['profileImage']}',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),

              // Profile Details Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ProfileDetailRow(icon: Icons.email, label: 'Email', value: user['email']),
                          ProfileDetailRow(icon: Icons.phone, label: 'Mobile', value: classOwner['mobileNumber']),
                          ProfileDetailRow(icon: Icons.verified_user, label: 'Role', value: user['role']),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Documents Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uploaded Documents',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DocumentRow(title: 'Aadhaar Card', filePath: classOwner['aadhaarCardFile']),
                          DocumentRow(title: 'PAN Card', filePath: classOwner['panCardFile']),
                          DocumentRow(title: 'Photograph', filePath: classOwner['photographFile']),
                          DocumentRow(title: 'Certificates', filePath: classOwner['certificatesFile']),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Update Profile Button
              if (widget.showUpdateOption)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() {
                            isLoading = true;
                          });

                          EasyLoading.show(status: 'Updating...');
                          try {
                            await updateClassOwner(
                              profileCont.token,
                              nameController.text,
                              mobileNumberController.text,
                            );
                            EasyLoading.showSuccess('Profile updated!');
                          } catch (e) {
                            EasyLoading.showError('Update failed!');
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                            EasyLoading.dismiss();
                          }
                        },
                        icon: const Icon(Icons.update),
                        label: const Text('Update Profile'),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class DocumentRow extends StatelessWidget {
  final String title;
  final String filePath;

  const DocumentRow({Key? key, required this.title, required this.filePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        final documentUrl =
            'https://classroom-api.raselhossen.tech/$filePath';
        print('Open document: $documentUrl');
      },
    );
  }
}
