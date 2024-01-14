import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/ui/home/home_screen.dart';
import 'package:hatly/ui/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/ui/login/login_screen_arguments.dart';
import 'package:hatly/ui/login/login_viewmodel.dart';
import 'package:hatly/ui/register/register_screen_arguments.dart';
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
  @override
  Widget build(BuildContext context) {
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
          print('success');
          Navigator.pushReplacementNamed(context, HomeScreen.routeName,
              arguments: HomeScreenArguments(args.countriesFlagsDto));
          UserProvider userProvider =
              BlocProvider.of<UserProvider>(context, listen: false);
          userProvider.login(LoggedInState(
              user: state.loginResponseDto.user!,
              token: state.loginResponseDto.token!));
          // Navigator.pushNamed(context, LoginScreen.routeName);
        }
      },
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/firstBack.png'),
                  fit: BoxFit.cover)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .26,
                      ),
                      const Text(
                        'Welcome Back To Hatly',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text(
                          'Please sign in with your email and password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: CustomFormField(
                          controller: emailController,
                          label: 'Email Address',
                          hint: 'Enter Your Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email == null || email.trim().isEmpty) {
                              return 'please enter email';
                            }
                            if (!ValidationUtils.isValidEmail(email)) {
                              return 'please enter email';
                            }
                          },
                        ),
                      ),
                      CustomFormField(
                        controller: passwordController,
                        label: 'Password',
                        hint: 'Enter Your Password',
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter password';
                          }
                          if (text.length < 6) {
                            return 'password should at least 6 chars';
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              child: Text(
                                'Forgot password',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              style: const ButtonStyle(
                                  overlayColor:
                                      MaterialStatePropertyAll(Colors.grey)),
                              onPressed: () {}),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 60),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              backgroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: () {
                            login();
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 30),
                          child: TextButton(
                            style: const ButtonStyle(
                                overlayColor:
                                    MaterialStatePropertyAll(Colors.grey)),
                            child: const Text(
                              'Don’t have an account? Create Account',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, RegisterScreen.routeName,
                                  arguments: RegisterScreenArguments(
                                      args.countriesFlagsDto));
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
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
