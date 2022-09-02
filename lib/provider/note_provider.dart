import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:notesnotes_app/models/note.dart';
import 'package:http/http.dart' as http;
import '../models/config.dart';
import '../models/http_exception.dart';

class NoteProvider with ChangeNotifier {
  List<NoteItem> _items = [];

  NoteProvider(this.userId, this.token, this._items);

  List<NoteItem> get items {
    return [..._items];
  }

  final int userId;
  final String token;

  dynamic _interceptResponseData(Response response) {
    final responseData = json.decode(response.body);
    if (response.statusCode != 200) {
      throw HttpException(response.statusCode, responseData['error']);
    }

    return responseData;
  }

  Map<String, String> _tokenHeader() {
    return {
      "Authorization": "Bearer $token",
    };
  }

  Future<void> insertNewNote(
    NoteItem noteItem,
  ) async {
    final url = Uri.parse("$mainApiUrl/insertnote");
    final param = json.encode(
      {
        "user_id": userId,
        "title": noteItem.title,
        "description": noteItem.description,
      },
    );
    try {
      final response = await http.post(
        url,
        body: param,
      );
      _interceptResponseData(response);
      await fetchAndSetNotes();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateNote(
    NoteItem newNote,
  ) async {
    final url = Uri.parse("$mainApiUrl/updatenote");
    final param = json.encode(
      {
        "user_id": userId,
        "note_id": newNote.id,
        "title": newNote.title,
        "description": newNote.description,
      },
    );
    try {
      final response = await http.post(
        url,
        body: param,
      );
      _interceptResponseData(response);
      await fetchAndSetNotes();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeNote(
    int noteId,
  ) async {
    final url = Uri.parse("$mainApiUrl/deletenote");
    final param = json.encode(
      {
        "user_id": userId,
        "note_id": noteId,
      },
    );
    try {
      final response = await http.delete(
        url,
        body: param,
        headers: _tokenHeader(),
      );
      _interceptResponseData(response);

      await fetchAndSetNotes();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetNotes() async {
    final url = Uri.parse("$mainApiUrl/notes?user_id=$userId");
    try {
      final response = await http.get(
        url,
        headers: _tokenHeader(),
      );
      final responseData = _interceptResponseData(response);
      List<NoteItem> loadedNotes = [];
      final extractedData = responseData as List<dynamic>;
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
