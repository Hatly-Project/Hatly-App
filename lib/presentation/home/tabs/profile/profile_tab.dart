import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/profile/edit_profile_screen.dart';
import 'package:hatly/presentation/home/tabs/profile/payment_information_screen.dart';
import 'package:hatly/presentation/home/tabs/profile/profile_screen_arguments.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'Profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isNightModeOn = false;
  late AccessTokenProvider accessTokenProvider;
  String? userName, userEmail, userImage;
  late HomeScreenArguments args;
  void toggleNightMode() {
    setState(() {
      isNightModeOn = !isNightModeOn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //     Provider.of<AccessTokenProvider>(context, listen: false);
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    // Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      userName =
          '${loggedInState.user.firstName} ${loggedInState.user.lastName}';
      userEmail = loggedInState.user.email;
      userImage = loggedInState.user.profilePhoto;
      // userId = loggedInState.user.id;
      // print('user iDDD $userId');
      // token = loggedInState.accessToken;
      // Now you can use the 'token' variable as needed in your code.
      // getAccessToken(accessTokenProvider).then(
      //   (accessToken) => viewModel.create(token),
      // );
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as HomeScreenArguments;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 250,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 14, 13, 13)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xFF30B2A3), width: 2.5),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.asset(
                                'images/me.jpg',
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName!,
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * .5,
                                child: Text(
                                  userEmail!,
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.lightBlue[900],
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Switch To Dark Mode',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: toggleNightMode,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF1D2429),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0.95, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 8, 0),
                                  child: Icon(
                                    Icons.nights_stay,
                                    color: isNightModeOn
                                        ? Colors.white
                                        : Color(0xFF95A1AC),
                                    size: 20,
                                  ),
                                ),
                              ),
                              isNightModeOn
                                  ? Align(
                                      alignment: AlignmentDirectional(-0.50, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 8, 0),
                                        child: Icon(
                                          Icons.nights_stay,
                                          color: isNightModeOn
                                              ? Colors.white
                                              : Color(0xFF95A1AC),
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              AnimatedAlign(
                                alignment: isNightModeOn
                                    ? AlignmentDirectional(0.85, 0)
                                    : AlignmentDirectional(-0.85, 0),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: isNightModeOn
                                        ? Colors.white
                                        : Color(0xFF14181B),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Color(0x430B0D0F),
                                        offset: Offset(
                                          0.0,
                                          2,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(30),
                                    shape: BoxShape.rectangle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
            child: Column(
              children: [
                Text(
                  'Account Details',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, EditProfileScreen.routeName,
                  arguments: ProfileScreenArguments(args.countriesFlagsDto));
            },
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Text(
                      'Edit Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: Color(0xFF95A1AC),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, PaymentInformationScreen.routeName);
            },
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Text(
                      'Payment Information',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: Color(0xFF95A1AC),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Text(
                      'Change Password',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: Color(0xFF95A1AC),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Text(
                      'My Deals',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 30,
                      color: Color(0xFF95A1AC),
                    ),
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.sizeOf(context).width * .5, 60),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () {
                  // login();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
