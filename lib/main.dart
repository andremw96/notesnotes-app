import 'package:flutter/material.dart';
import 'package:notesnotes_app/provider/auth_provider.dart';
import 'package:notesnotes_app/provider/note_provider.dart';
import 'package:notesnotes_app/screens/add_edit_note_screen.dart';
import 'package:notesnotes_app/screens/auth_screen.dart';
import 'package:notesnotes_app/screens/note_list_screen.dart';
import 'package:notesnotes_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, NoteProvider>(
            update: (context, auth, previous) => NoteProvider(
              auth.userId == null ? -1 : auth.userId!,
            ),
            create: (context) => NoteProvider(-1),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) => MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: auth.isAuth
                ? NoteListScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              AddEditNoteScreen.routeName: (ctx) => const AddEditNoteScreen(),
            },
          ),
        ));
  }
}
