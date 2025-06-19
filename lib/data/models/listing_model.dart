import 'dart:convert';
import 'package:lms/data/models/file_entity.dart';

class Listing {
  final int? id;
  final String username;
  final String title;
  final String description;
  final DateTime? creationDate;
  final DateTime? approvalDate;
  final bool? approved;
  final List<String> types;
  final DateTime? eventDate;
  final List<FileEntity>? files;

  Listing({
    this.id,
    required this.username,
    required this.title,
    required this.description,
    this.creationDate,
    this.approvalDate,
    this.approved,
    required this.types,
    this.eventDate,
    this.files,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'],
      username: json['username'],
      title: json['title'],
      description: json['description'],
      creationDate: json['creationDate'] != null
          ? DateTime.parse(json['creationDate'])
          : null,
      approvalDate: json['approvalDate'] != null
          ? DateTime.parse(json['approvalDate'])
          : null,
      approved: json['approved'],
      types: List<String>.from(json['types']),
      eventDate: json['eventDate'] != null
          ? DateTime.parse(json['eventDate'])
          : null,
      files: json['files'] != null
          ? (json['files'] as List)
              .map((e) => FileEntity.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'title': title,
      'description': description,
      'creationDate': creationDate?.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'approved': approved,
      'types': types,
      'eventDate': eventDate?.toIso8601String(),
      'files': files?.map((f) => f.toJson()).toList(),
    };
  }
}
