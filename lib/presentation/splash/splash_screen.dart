import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/presentation/home/home_screen.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/welcome/welcome_screen.dart';
import 'package:hatly/presentation/welcome/welcome_screen_arguments.dart';

import '../login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'Splash';
  ApiManager apiManager = ApiManager();
  CountriesDto? countriesList;

  Future<CountriesDto> getCountriesFlags() async {
    var response = await apiManager.getCountriesFlags();
    var countries = response.toCountriesDto();
    countriesList = countries;
    return countriesList!;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

    getCountriesFlags().then((countries) => userProvider.state is LoggedInState
        ? Navigator.pushReplacementNamed(context, HomeScreen.routeName,
            arguments: HomeScreenArguments(countries))
        : Navigator.pushReplacementNamed(context, WelcomeScreen.routeName,
            arguments: WelcomeScreenArguments(countries)));
    return Scaffold(
      body: Image.asset(
        'images/splash.png',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
