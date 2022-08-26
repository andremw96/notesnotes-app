import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoteListScreen extends StatelessWidget {
  static const routeName = "/note-list";

  const NoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Notes"),
      ),
      body: Center(
        child: Text(
          "My Note List",
        ),
      ),
    );
  }
}
