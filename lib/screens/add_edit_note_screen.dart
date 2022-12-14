import 'package:flutter/material.dart';
import 'package:notesnotes_app/models/note.dart';
import 'package:notesnotes_app/provider/note_provider.dart';
import 'package:notesnotes_app/widget/dialog_logout_widget.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  static const routeName = "/add-edit-note";

  const AddEditNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _form = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  var _initValues = {
    'title': '',
    'description': '',
  };
  var _isLoading = false;
  var _isEdit = true;
  var _note = NoteItem(
    id: null,
    title: "title",
    description: "description",
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  );

  @override
  void didChangeDependencies() {
    if (_isEdit) {
      final note = ModalRoute.of(context)?.settings.arguments;
      if (note != null) {
        note as NoteItem;
        _initValues = {
          'title': note.title,
          'description': note.description,
        };
        _note = note;
      }
    }
    _isEdit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveForm(ScaffoldMessengerState scaffold) async {
    if (_form.currentState != null) {
      final isValid = _form.currentState?.validate();
      if (isValid!) {
        _form.currentState!.save();
        setState(() {
          _isLoading = true;
        });

        try {
          if (_note.id != null) {
            await Provider.of<NoteProvider>(context, listen: false)
                .updateNote(_note);
          } else {
            await Provider.of<NoteProvider>(context, listen: false)
                .insertNewNote(_note);
          }
          Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                  },
                ),
              ),
            );
          } else {
            await showDialog<Null>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("An error occured!"),
                content: Text(
                  error.toString(),
                ),
                actions: [
                  FlatButton(
                    child: const Text("Okay!"),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  )
                ],
              ),
            );
          }
        }

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: () => _saveForm(scaffold),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _note = NoteItem(
                          id: _note.id,
                          title: value!,
                          description: _note.description,
                          createdAt: _note.createdAt,
                          updatedAt: _note.updatedAt,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Pleas fill value";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      maxLines: null,
                      onSaved: (value) {
                        _note = NoteItem(
                          id: _note.id,
                          title: _note.title,
                          description: value!.trim(),
                          createdAt: _note.createdAt,
                          updatedAt: _note.updatedAt,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Pleas enter a description";
                        }
                        if (value.length < 10) {
                          return "should be at least 10 characters long";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
