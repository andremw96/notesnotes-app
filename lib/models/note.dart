import 'package:flutter/material.dart';

class NoteItem with ChangeNotifier {
  final int? id;
  final String title;
  final String description;
  final DateTime updatedAt;
  final DateTime createdAt;

  NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.updatedAt,
    required this.createdAt,
  });
}
