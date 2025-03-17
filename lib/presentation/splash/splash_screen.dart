import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/customException/custom_exception.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/presentation/home/home_screen.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/welcome/welcome_screen.dart';
import 'package:hatly/presentation/welcome/welcome_screen_arguments.dart';
import 'package:hatly/providers/countries_list_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'Splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ApiManager apiManager = ApiManager();
  CountriesDto? countriesList;
  bool? tokenValid;
  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Define the animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceIn,
    );

    // Add listener to animation status
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        UserProvider userProvider =
            BlocProvider.of<UserProvider>(context, listen: false);
        print("state ${userProvider.state}");
        checkAndNavigate();
      }
    });

    // Start the animation
    _controller.forward();
  }

  void checkAndNavigate() async {
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    countriesList = await getCountriesFlags().then((countries) {
      context
          .read<CountriesListProvider>()
          .setCountriesList(countries: countries!);

      return countries;
    });
    print("ssss");
    if (userProvider.state is LoggedInState) {
      if ((await isTokenValid())!) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName,
            arguments: HomeScreenArguments(countriesList!));
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName,
            arguments: WelcomeScreenArguments(countriesList!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Theme.of(context).primaryColor,
          statusBarIconBrightness: Brightness.light),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            "images/splash_logo.png",
            fit: BoxFit.cover,
            width: 435,
            height: 436,
          ),
        ),
      ),
    );
  }

  Future<bool?> isTokenValid() async {
    try {
      tokenValid = await apiManager.chechAccessTokenExpired();
    } on ServerErrorException catch (e) {
      DialogUtils.showDialogIos(
          context: context, alertMsg: 'Fail', alertContent: e.errorMessage);
    } on Exception catch (e) {
      DialogUtils.showDialogIos(
          context: context, alertMsg: 'Fail', alertContent: e.toString());
    }
    return tokenValid;
  }

  Future<CountriesDto?> getCountriesFlags() async {
    try {
      var response = await apiManager.getCountriesFlags();
      var countries = response.toDto();
      countriesList = countries;
    } on ServerErrorException catch (e) {
      DialogUtils.showDialogIos(
          context: context, alertMsg: 'Fail', alertContent: e.errorMessage);
    } on Exception catch (e) {
      DialogUtils.showDialogIos(
          context: context, alertMsg: 'Fail', alertContent: e.toString());
    }
    return countriesList;
  }

  @override
  void dispose() {
    // Dispose the animation controller to free up resources
    _controller.dispose();
    super.dispose();
  }
}
