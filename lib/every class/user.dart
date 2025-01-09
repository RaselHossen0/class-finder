import 'package:class_rasel/Global.dart';

class User {
  late String name;
  late String email;
  String profileImage;
  String? mobileNumber; // Nullable: Can be null if not provided
  String? alternateMobileNumber; // Nullable: Can be null if not provided
  String? adharCardNum; // Nullable: Can be null if not provided
  String? panCardNum; // Nullable: Can be null if not provided
  String? photo; // Nullable: Can be null if not provided
  List<String> certificates = []; // Nullable: Can be empty but cannot be null
  String? aadharCardFile; // Nullable: Can be null if not provided
  String? panCardFile; // Nullable: Can be null if not provided
  String? className; // Nullable: Can be null if not provided
  String? description; // Nullable: Can be null if not provided
  String? locationName; // Nullable: Can be null if not provided
  List<double> latLang = []; // Required, but can be an empty list, not nullable
  String? price; // Nullable: Can be null if not provided
  late String role; // Non-nullable: Must be provided
  int? category; // Nullable: Can be null if not provided
  int? rating; // Nullable: Can be null if not provided

  // Constructor with required and optional parameters
  User({
    required this.name,
    required this.email,
    required this.profileImage,
    this.mobileNumber, // Optional: Can be null
    this.alternateMobileNumber, // Optional: Can be null
    this.adharCardNum, // Optional: Can be null
    this.panCardNum, // Optional: Can be null
    this.photo, // Optional: Can be null
    this.certificates = const [], // Default empty list, not nullable
    this.aadharCardFile, // Optional: Can be null
    this.panCardFile, // Optional: Can be null
    this.className, // Optional: Can be null
    this.description, // Optional: Can be null
    this.locationName, // Optional: Can be null
    required this.latLang, // Required: Must be provided (GeoJSON coordinates)
    this.price, // Optional: Can be null
    required this.role, // Required: Must be provided
    this.category, // Optional: Can be null
    this.rating, // Optional: Can be null
  });
  factory User.fromJson(Map<String, dynamic> json) {
    print("User.fromJson: $json");
    User user = User(
      name: json["user"]['name'],
      email: json["user"]['email'],
      profileImage: rootApi + json['user']['profileImage'],
      latLang: [], // Initialize with an empty list
      role: json['user']['role'],
    );

    if (json['user']['role'] == 'class_owner') {
      user.mobileNumber = json['classOwner']['mobileNumber'];
      user.alternateMobileNumber = json['classOwner']['alternateMobileNumber'];
      user.adharCardNum = json['classOwner']['aadhaarCardNumber'];
      user.panCardNum = json['classOwner']['panCardNumber'];
      user.aadharCardFile =
          rootApi + "/" + json['classOwner']['aadhaarCardFile'];
      user.panCardFile = rootApi + "/" + json['classOwner']['panCardFile'];
      user.photo = rootApi + json['classOwner']['photographFile'];
    }

    return user;
  }
}
