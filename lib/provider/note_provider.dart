import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notesnotes_app/models/note.dart';
import 'package:http/http.dart' as http;
import '../models/config.dart';
import '../models/http_exception.dart';

class NoteProvider with ChangeNotifier {
  List<NoteItem> _items = [];

  NoteProvider(this.userId);

  List<NoteItem> get items {
    return [..._items];
  }

  final int userId;

  Future<void> fetchAndSetNotes() async {
    final url = Uri.parse("$mainApiUrl/notes?user_id=$userId");
    try {
      final response = await http.get(
        url,
      );
      List<NoteItem> loadedNotes = [];
      final extractedData = json.decode(response.body) as List<dynamic>;
      if (extractedData == null) {
        return;
      }
      for (var value in extractedData) {
        loadedNotes.add(
          NoteItem(
            id: value["id"],
            title: value["title"],
            description: value["description"]["String"],
            updatedAt: DateTime.parse(value["updated_at"]),
            createdAt: DateTime.parse(value["created_at"]),
          ),
        );
      }
      _items = loadedNotes.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
