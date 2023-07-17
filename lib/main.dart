import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hatly/ui/login/login_screen.dart';
import 'package:hatly/ui/register/register_screen.dart';
import 'package:hatly/ui/splash/splash_screen.dart';
import 'package:hatly/ui/welcome/welcome_screen.dart';

import 'firebase_options.dart';
import 'my_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        RegisterScreen.routeName: (context) => RegisterScreen(),
        WelcomeScreen.routeName: (context) => WelcomeScreen()
      },
    );
  }
}
