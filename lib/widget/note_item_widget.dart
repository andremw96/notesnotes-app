import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:notesnotes_app/screens/add_edit_note_screen.dart';

import '../models/note.dart';

class NoteItemWidget extends StatelessWidget {
  const NoteItemWidget({Key? key, required this.noteItem}) : super(key: key);

  final NoteItem noteItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            onTap: () => {
              Navigator.of(context).pushNamed(
                AddEditNoteScreen.routeName,
                arguments: noteItem,
              )
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  noteItem.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat("dd MMM yyyy hh:mm").format(noteItem.updatedAt),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  noteItem.description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
