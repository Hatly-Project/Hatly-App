import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/ui/home/tabs/home/home_tab.dart';
import 'package:hatly/ui/login/login_screen.dart';
import 'package:hatly/ui/login/login_screen_arguments.dart';
import 'package:hatly/ui/register/register_screen.dart';
import 'package:hatly/ui/register/register_screen_arguments.dart';
import 'package:hatly/ui/welcome/welcome_screen_arguments.dart';

import '../../providers/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = 'Welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    late String token;

    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      token = loggedInState.token;
      Navigator.pushNamed(context, HomeTab.routeName);
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as WelcomeScreenArguments;
    var countriesList = args.countriesFlagsDto.countries;
    print(countriesList!.first.name);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/welcome.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Hatly',
                style: GoogleFonts.poppins(
                    fontSize: 70,
                    color: Color(0xFF2F2651),
                    fontWeight: FontWeight.w500),
              ),
            ),
            Center(
              child: Text(
                'Your Gateway\n to Global Shopping!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Color(0xFF2F2651),
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName,
                          arguments:
                              LoginScreenArguments(args.countriesFlagsDto));
                    },
                    style: ElevatedButton.styleFrom(
                        // minimumSize: Size(double.infinity, 10),
                        fixedSize: Size(156, 48),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17)),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, RegisterScreen.routeName,
                          arguments:
                              RegisterScreenArguments(args.countriesFlagsDto));
                    },
                    style: ElevatedButton.styleFrom(
                        // minimumSize: Size(double.infinity, 10),
                        fixedSize: Size(156, 48),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17)),
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 90,
            )
          ],
        ),
      ),
    );
  }
}
