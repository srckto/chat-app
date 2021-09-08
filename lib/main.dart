import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/auth_screen.dart' show AuthScreen;
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat App",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Color.fromRGBO(225, 52, 30, 1),
        backgroundColor: Color.fromRGBO(220, 35, 88, 1),
        accentColor: Color.fromRGBO(119, 43, 212, 1),
        accentColorBrightness: Brightness.dark,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext ctx, AsyncSnapshot snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (snapShot.hasData)
              return ChatScreen();
            else
              return AuthScreen();
          }),
    );
  }
}
