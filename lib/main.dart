import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/firebase_options.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/ui/home/home_screen.dart';
import 'package:hatly/ui/home/tabs/trips/create_trip_screen.dart';
import 'package:hatly/ui/home/tabs/trips/my_trips.dart';
import 'package:hatly/ui/login/login_screen.dart';
import 'package:hatly/ui/register/register_screen.dart';
import 'package:hatly/ui/splash/splash_screen.dart';
import 'package:hatly/ui/welcome/welcome_screen.dart';
import 'package:hive/hive.dart';
import 'my_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Open the Hive box for shipments
  await Hive.openBox('shipments');
  runApp(BlocProvider(
      create: (BuildContext context) {
        return UserProvider();
      },
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: MyTheme.primaryColor,
          scaffoldBackgroundColor: MyTheme.backgroundColor),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        MyTripsTab.routeName: (context) => MyTripsTab(),
        HomeScreen.routeName: (context) => HomeScreen(),
        CreateTripScreen.routeName: (context) => CreateTripScreen()
      },
    );
  }
}
