import 'package:flutter/material.dart';
import 'package:notesnotes_app/models/note.dart';

class NoteProvider with ChangeNotifier {
  List<NoteItem> _items = [
    NoteItem(
      id: "1",
      title: "title",
      description: "description",
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    ),
    NoteItem(
      id: "2",
      title: "titl2",
      description: "description2",
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    ),
  ];

  List<NoteItem> get items {
    return [..._items];
  }

  Future<void> fetchAndSetNotes() async {
    await Future.value(_items);
    notifyListeners();
  }
}
