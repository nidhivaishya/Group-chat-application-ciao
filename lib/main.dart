import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/chat.dart';
import './screens/auth.dart';
import './screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ciao',
            darkTheme: ThemeData(
              brightness: Brightness.dark,
            ),
            theme: ThemeData(
              primarySwatch: Colors.cyan,
              backgroundColor: Colors.cyanAccent,
              accentColor: Colors.cyanAccent,
              accentColorBrightness: Brightness.light,
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.cyan,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            // home: StreamBuilder(
            home: appSnapshot.connectionState != ConnectionState.done
                ? SplashScreen()
                : StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      if (userSnapshot.hasData) {
                        return Chat();
                      }
                      return AuthScreen();
                    }),
          );
        });
  }
}
