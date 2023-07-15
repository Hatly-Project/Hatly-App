import 'package:flutter/material.dart';
import 'package:hatly/ui/login/login_screen.dart';
import 'package:hatly/ui/splash/splash_screen.dart';
import 'package:hatly/ui/welcome/welcome_screen.dart';

import 'my_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: MyTheme.primaryColor,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        WelcomeScreen.routeName: (context) => WelcomeScreen()
      },
    );
  }
}
