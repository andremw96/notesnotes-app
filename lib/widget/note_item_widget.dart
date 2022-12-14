import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:notesnotes_app/provider/note_provider.dart';
import 'package:notesnotes_app/screens/add_edit_note_screen.dart';
import 'package:notesnotes_app/screens/auth_screen.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../provider/auth_provider.dart';
import 'dialog_logout_widget.dart';

class NoteItemWidget extends StatelessWidget {
  const NoteItemWidget({Key? key, required this.noteItem}) : super(key: key);

  final NoteItem noteItem;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        try {
          await Provider.of<NoteProvider>(context, listen: false).removeNote(
            noteItem.id!,
          );
        } catch (error) {
          if (error.toString().contains("401")) {
            scaffold.showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                action: SnackBarAction(
                  label: "Relogin",
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .logout();
                  },
                ),
              ),
            );
          } else {
            scaffold.showSnackBar(
              const SnackBar(
                content: Text("deleting failed!"),
              ),
            );
          }
        }
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text(
              "Are you sure",
            ),
            content: Text(
              "Do you want to remove ${noteItem.title}?",
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("No"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        );
      },
      child: Card(
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
      ),
    );
  }
}
