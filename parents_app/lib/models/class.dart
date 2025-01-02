import 'dart:convert';

import 'package:class_finder/constants.dart';
import 'package:class_finder/models/category.dart';

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
    // print(json);
    return ClassModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      price: json['price'],
      rating: json['rating'].toDouble(),
      category: Category.fromJson(json['Category']),
      coords: Coords(
        lat: double.parse(json['coordinates']['coordinates'][0].toString()),
        lng: double.parse(json['coordinates']['coordinates'][1].toString()),
      ),
      ClassOwnerId: json['ClassOwner']['id'],
      media: medias,
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
      url: frontEndUrl + "/" + json['url'],
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
