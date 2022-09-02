import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:notesnotes_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class DialogLogoutWidget extends StatelessWidget {
  const DialogLogoutWidget({Key? key, required this.errorString})
      : super(key: key);

  final String errorString;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("An error occured!"),
      content: Text(
        errorString,
      ),
      actions: [
        FlatButton(
          child: const Text("Logout!"),
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
