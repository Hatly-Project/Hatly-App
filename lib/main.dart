import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hatly/firebase_options.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/presentation/home/home_screen.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_details.dart';
import 'package:hatly/presentation/home/tabs/trips/create_trip_screen.dart';
import 'package:hatly/presentation/home/tabs/trips/my_trips.dart';
import 'package:hatly/presentation/home/tabs/trips/trip_details.dart';
import 'package:hatly/presentation/login/login_screen.dart';
import 'package:hatly/presentation/register/register_screen.dart';
import 'package:hatly/presentation/splash/splash_screen.dart';
import 'package:hatly/presentation/welcome/welcome_screen.dart';
import 'package:hatly/providers/firebase_messaging_provider.dart';
import 'package:hatly/services/local_notifications_service.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'my_theme.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService().initNotification();

  var fcmToken = await FirebaseMessaging.instance.getToken();
  print('fcm Token: $fcmToken');

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // Open the Hive box for shipments
  await Hive.openBox('shipments');

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => FCMProvider(),
        ),
        // Add more providers as needed
      ],
      child: MyApp(),
    ),
  );
  // runApp(BlocProvider(
  //     create: (BuildContext context) {
  //       return UserProvider();
  //     },
  //     child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FCMProvider fcmProvider = Provider.of<FCMProvider>(context);
    print('Notification Message: ${fcmProvider.notifMessage?.body}');

    if (fcmProvider.notifMessage != null) {
      NotificationService().showNotification(
          title: fcmProvider.notifMessage?.title,
          body: fcmProvider.notifMessage?.body);
    }
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: MyTheme.primaryColor,
          scaffoldBackgroundColor: MyTheme.backgroundColor),
      initialRoute: SplashScreen.routeName,
      home: MultiProvider(providers: [
        BlocProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => FCMProvider(),
        ),
        // Add more providers as needed
      ]),
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        WelcomeScreen.routeName: (context) => WelcomeScreen(),
        MyTripsTab.routeName: (context) => MyTripsTab(),
        HomeScreen.routeName: (context) => HomeScreen(),
        CreateTripScreen.routeName: (context) => CreateTripScreen(),
        ShipmentDetails.routeName: (context) => ShipmentDetails(),
        TripDetails.routeName: (context) => TripDetails(),
        MyShipmentDetails.routeName: (context) => MyShipmentDetails()
      },
    );
  }
}
