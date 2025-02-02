class Rating {
  final int id;
  final int userId;
  final int classId;
  final double rating;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final User user;

  Rating({
    required this.id,
    required this.userId,
    required this.classId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      userId: json['userId'],
      classId: json['classId'],
      rating: json['rating'].toDouble(),
      comment: json['comment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: User.fromJson(json['User']),
    );
  }
}

class User {
  final int id;
  final String name;
  final String profileImage;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      email: json['email'],
    );
  }
}
