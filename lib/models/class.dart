import 'dart:convert';

import 'package:class_rasel/Global.dart';
import 'package:class_rasel/models/category.dart';

class ClassModel {
  final int id;
  final String name;
  final String description;
  final String location;
  final int price;
  final double rating;
  final Category category;
  final Coords coords;
  final int ClassOwnerId;

  static initial() {
    return ClassModel(
      id: 0,
      name: '',
      description: '',
      location: '',
      price: 0,
      rating: 0.0,
      category: Category(
          id: 0,
          name: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()),
      coords: Coords(lat: 0.0, lng: 0.0),
      ClassOwnerId: 0,
    );
  }

  List<Media> media;

  ClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.price,
    required this.rating,
    required this.category,
    required this.coords,
    required this.ClassOwnerId,
    this.media = const [],
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    final List<Media> medias = json['Media'] != null
        ? List<Media>.from(json['Media'].map((x) => Media.fromJson(x)))
        : [];
    return ClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      price: json['price'] ?? 0,
      rating: (json['rating'] != null) ? json['rating'].toDouble() : 0.0,
      category: Category.fromJson(json['Category'] ?? {}),
      coords: Coords(
        lat: (json['coordinates'] != null &&
                json['coordinates']['coordinates'] != null)
            ? double.parse(json['coordinates']['coordinates'][0].toString())
            : 0.0,
        lng: (json['coordinates'] != null &&
                json['coordinates']['coordinates'] != null)
            ? double.parse(json['coordinates']['coordinates'][1].toString())
            : 0.0,
      ),
      ClassOwnerId: (json['ClassOwner'] != null) ? json['ClassOwner']['id'] : 0,
      media: medias,
    );
  }

  ClassModel copyWith({required String name, required String description}) {
    return ClassModel(
      id: this.id,
      name: name,
      description: description,
      location: this.location,
      price: this.price,
      rating: this.rating,
      category: this.category,
      coords: this.coords,
      ClassOwnerId: this.ClassOwnerId,
      media: this.media,
    );
  }
}

List<ClassModel> parseClasses(String responseBody) {
  final parsed = jsonDecode(responseBody)['classes'] as List;
  // print(parsed);
  return parsed.map((json) => ClassModel.fromJson(json)).toList();
}

class Coords {
  final double lat;
  final double lng;

  Coords({required this.lat, required this.lng});
}

class Media {
  final int id;
  final String type;
  final String url;
  final String title;
  final String description;
  final String tags;
  final DateTime uploadDate;
  final int classId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCoverImage;

  Media(
      {required this.id,
      required this.type,
      required this.url,
      required this.title,
      required this.description,
      required this.tags,
      required this.uploadDate,
      required this.classId,
      required this.createdAt,
      required this.updatedAt,
      required this.isCoverImage});

  factory Media.fromJson(Map<String, dynamic> json) {
    // print(json['isCoverImage'] == true);
    return Media(
      id: json['id'],
      type: json['type'],
      url: json['url'],
      title: json['title'],
      description: json['description'],
      tags: json['tags'],
      uploadDate: DateTime.parse(json['upload_date']),
      classId: json['classId'],
      isCoverImage: json['isCoverImage'] == true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
