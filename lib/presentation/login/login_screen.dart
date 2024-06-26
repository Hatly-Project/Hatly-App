import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hatly/data/api/api_manager.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/presentation/home/home_screen.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/login/login_screen_arguments.dart';
import 'package:hatly/presentation/login/login_viewmodel.dart';
import 'package:hatly/presentation/register/register_screen_arguments.dart';
import 'package:hatly/providers/firebase_messaging_provider.dart';
import 'package:provider/provider.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/validation_utils.dart';
import '../components/custom_text_field.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'Login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var connectivityResult;

  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController(text: '');

  var passwordController = TextEditingController(text: '');

  LoginViewModel viewModel = LoginViewModel();
  FlutterSecureStorage storage = const FlutterSecureStorage();
  String? refreshToken;

  Future<String?> getRefreshToken() async {
    print('aaaaaaaaaaaaa');
    String? refreshToken = await storage.read(key: 'refreshToken');
    if (refreshToken == null) {
      print('token null');
    } else {
      print('token success');
    }
    return refreshToken;
  }

  @override
  Widget build(BuildContext context) {
    FCMProvider fcmProvider = Provider.of<FCMProvider>(context);
    AccessTokenProvider accessTokenProvider =
        Provider.of<AccessTokenProvider>(context);

    final args =
        ModalRoute.of(context)!.settings.arguments as LoginScreenArguments;
    return BlocConsumer(
      bloc: viewModel,
      buildWhen: (previous, current) {
        if (current is LoginInitialState) {
          return true;
        }
        return false;
      },
      listenWhen: (previous, current) {
        if (previous is LoginLoadingState) {
          DialogUtils.hideDialog(context);
        }
        if (current is LoginLoadingState ||
            current is LoginSuccessState ||
            current is LoginFailState) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is LoginFailState) {
          if (Platform.isIOS) {
            DialogUtils.showDialogIos(
                alertMsg: 'Fail',
                alertContent: state.failMessage,
                context: context);
          } else {
            DialogUtils.showDialogAndroid(
                alertMsg: 'Fail',
                alertContent: state.failMessage,
                context: context);
          }
        } else if (state is LoginLoadingState) {
          if (Platform.isIOS) {
            DialogUtils.showDialogIos(
                alertMsg: 'Loading',
                alertContent: state.loadingMessage,
                context: context);
          } else {
            DialogUtils.showDialogAndroid(
                alertMsg: 'Loading',
                alertContent: state.loadingMessage,
                context: context);
          }
          print('load');
        } else if (state is LoginSuccessState) {
          getRefreshToken().then((refreshToken) {
            UserProvider userProvider =
                BlocProvider.of<UserProvider>(context, listen: false);
            print('iddd ${state.loginResponseDto.user}');
            userProvider.login(LoggedInState(
              user: state.loginResponseDto.user!,
              accessToken: state.loginResponseDto.accessToken!,
              refreshToken: refreshToken!,
            ));
            accessTokenProvider
                .setAccessToken(state.loginResponseDto.accessToken!);
          });

          if (Platform.isAndroid) {
            fcmProvider.loginAndRefresh();
          }
          // if (fcmProvider.fcmToken != null) {
          //   ApiManager().refreshFCMToken(
          //       token: state.loginResponseDto.token!,
          //       fcmToken: fcmProvider.fcmToken!);
          // }
          print('success');
          Navigator.pushReplacementNamed(context, HomeScreen.routeName,
              arguments: HomeScreenArguments(args.countriesFlagsDto));
          // Navigator.pushNamed(context, LoginScreen.routeName);
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Stack(
              children: [
                Image.asset(
                  'images/top_corner.png',
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.sizeOf(context).width * .44),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back to ',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Text('Hatly',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        'Please login with your email and password to \nbe able to use our app',
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(left: 20, right: 30),
                      child: CustomFormField(
                        controller: emailController,
                        label: 'Email Address',
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter email';
                          }
                          if (!ValidationUtils.isValidEmail(text)) {
                            return 'please enter a valid email';
                          }
                        },
                      ),
                    ),
                    Container(
                      // margin: const EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(left: 20, right: 30),
                      child: CustomFormField(
                        controller: emailController,
                        label: 'Password',
                        hint: 'Password',
                        keyboardType: TextInputType.emailAddress,
                        suffixICon: Icon(Icons.visibility_outlined),
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter email';
                          }
                          if (!ValidationUtils.isValidEmail(text)) {
                            return 'please enter a valid email';
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forget Password?',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    color: Color(0xFF5A5A5A),
                                    fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 60),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                            side: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 1),
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () {
                          // register();
                        },
                        child: Text(
                          'Log in',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.sizeOf(context).width * .1),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Divider(
                                thickness: 1,
                                color: Color(0xFFD6D6D6),
                              ),
                            ),
                          ),
                          Text(
                            ' or Log in with... ',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Divider(
                                thickness: 1,
                                color: Color(0xFFD6D6D6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 20,
                              left: 16,
                              right: 16,
                            ),
                            // padding: EdgeInsets.only(left: 20, right: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 60),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  side: BorderSide(
                                      color: Color(0xFFD6D6D6), width: 1),
                                  backgroundColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () {
                                // register();
                              },
                              child: Image.asset(
                                'images/devicon_google.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(top: 20, right: 16),
                            // padding: EdgeInsets.only(left: 20, right: 20),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 60),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  side: BorderSide(
                                      color: Color(0xFFD6D6D6), width: 1),
                                  backgroundColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () {
                                // register();
                              },
                              child: Image.asset(
                                'images/apple_icon.png',
                                width: 24,
                                height: 24,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
            // SingleChildScrollView(
            //   child: Padding(
            //     padding: const EdgeInsets.all(15.0),
            //     child: Form(
            //       key: formKey,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: [
            //           SizedBox(
            //             height: MediaQuery.of(context).size.height * .26,
            //           ),
            //           const Text(
            //             'Welcome Back To Hatly',
            //             style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 26,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //           Container(
            //             margin: const EdgeInsets.only(top: 5),
            //             child: const Text(
            //               'Please sign in with your email and password',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 15,
            //               ),
            //             ),
            //           ),
            //           const SizedBox(height: 25),
            //           Container(
            //             margin: const EdgeInsets.only(bottom: 25),
            //             child: CustomFormField(
            //               controller: emailController,
            //               label: 'Email Address',
            //               hint: 'Enter Your Email',
            //               keyboardType: TextInputType.emailAddress,
            //               validator: (email) {
            //                 if (email == null || email.trim().isEmpty) {
            //                   return 'please enter email';
            //                 }
            //                 if (!ValidationUtils.isValidEmail(email)) {
            //                   return 'please enter email';
            //                 }
            //               },
            //             ),
            //           ),
            //           CustomFormField(
            //             controller: passwordController,
            //             label: 'Password',
            //             hint: 'Enter Your Password',
            //             keyboardType: TextInputType.text,
            //             isPassword: true,
            //             validator: (text) {
            //               if (text == null || text.trim().isEmpty) {
            //                 return 'please enter password';
            //               }
            //               if (text.length < 6) {
            //                 return 'password should at least 6 chars';
            //               }
            //             },
            //           ),
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.end,
            //             children: [
            //               TextButton(
            //                   child: Text(
            //                     'Forgot password',
            //                     style: TextStyle(
            //                         color: Colors.white, fontSize: 15),
            //                   ),
            //                   style: const ButtonStyle(
            //                       overlayColor:
            //                           MaterialStatePropertyAll(Colors.grey)),
            //                   onPressed: () {}),
            //             ],
            //           ),
            //           Container(
            //             margin: const EdgeInsets.only(top: 10),
            //             child: ElevatedButton(
            //               style: ElevatedButton.styleFrom(
            //                   minimumSize: Size(double.infinity, 60),
            //                   elevation: 0,
            //                   shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(15)),
            //                   side: BorderSide(
            //                       color: Theme.of(context).primaryColor,
            //                       width: 1),
            //                   backgroundColor: Colors.white,
            //                   padding:
            //                       const EdgeInsets.symmetric(vertical: 12)),
            //               onPressed: () {
            //                 login();
            //               },
            //               child: Text(
            //                 'Login',
            //                 style: TextStyle(
            //                     fontSize: 24,
            //                     color: Theme.of(context).primaryColor),
            //               ),
            //             ),
            //           ),
            //           Center(
            //             child: Container(
            //               margin: const EdgeInsets.only(top: 30),
            //               child: TextButton(
            //                 style: const ButtonStyle(
            //                     overlayColor:
            //                         MaterialStatePropertyAll(Colors.grey)),
            //                 child: const Text(
            //                   'Don’t have an account? Create Account',
            //                   style:
            //                       TextStyle(fontSize: 17, color: Colors.white),
            //                 ),
            //                 onPressed: () {
            //                   Navigator.pushReplacementNamed(
            //                       context, RegisterScreen.routeName,
            //                       arguments: RegisterScreenArguments(
            //                           args.countriesFlagsDto));
            //                 },
            //               ),
            //             ),
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            );
      },
    );
  }

  Future<bool> checkInternetConnection() async {
    connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return true;
  }

  void login() async {
    // async - await
    if (formKey.currentState?.validate() == false &&
        await checkInternetConnection()) {
      return;
    }
    viewModel.login(emailController.text, passwordController.text);
  }
}
