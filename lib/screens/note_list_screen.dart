import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notesnotes_app/provider/auth_provider.dart';
import 'package:notesnotes_app/provider/note_provider.dart';
import 'package:notesnotes_app/widget/note_item_widget.dart';
import 'package:provider/provider.dart';

enum PopupMenu {
  Logout,
}

class NoteListScreen extends StatefulWidget {
  static const routeName = "/note-list";

  const NoteListScreen({Key? key}) : super(key: key);

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  Future<void>? _notesFuture = null;
  Future _obtainNotesFuture() {
    return Provider.of<NoteProvider>(context, listen: false).fetchAndSetNotes();
  }

  @override
  void initState() {
    _notesFuture = _obtainNotesFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              if (selectedValue == PopupMenu.Logout) {
                Provider.of<AuthProvider>(context, listen: false).logout();
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: PopupMenu.Logout,
                child: Text("Logout"),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesFuture,
        builder: (ctx, datasnapshot) {
          if (datasnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (datasnapshot.error != null) {
              return const Center(child: Text("an error occured"));
            } else {
              return Consumer<NoteProvider>(builder: (ctx, notes, child) {
                return ListView.builder(
                  itemCount: notes.items.length,
                  itemBuilder: (context, i) => NoteItemWidget(
                    noteItem: notes.items[i],
                  ),
                );
              });
            }
          }
        },
      ),
    );
  }
}
