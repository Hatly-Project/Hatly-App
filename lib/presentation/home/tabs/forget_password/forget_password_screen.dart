import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/home/tabs/forget_password/forget_password_code_screen.dart';
import 'package:hatly/presentation/home/tabs/forget_password/forget_passwrod_screen_viewmodel.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:hatly/utils/validation_utils.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = 'forgetPassword';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  ForgetPasswrodScreenViewmodel viewmodel = ForgetPasswrodScreenViewmodel();
  var formKey = GlobalKey<FormState>();
  var connectivityResult;

  var emailController = TextEditingController(text: '');

  bool _isButtonEnabled = false, _obscurePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    emailController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    // Check if both fields are non-empty
    if (emailController.text.trim().isNotEmpty) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: viewmodel,
      listener: (context, state) {
        if (state is ResetEmailFailState) {
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
        } else if (state is ResetEmailLoadingState) {
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
        } else if (state is ResetEmailSuccessState) {
          print('success');
          Navigator.pushReplacementNamed(
              context, ForgetPasswordOtpScreen.routeName);
        }
      },
      listenWhen: (previous, current) {
        if (previous is ResetEmailLoadingState) {
          DialogUtils.hideDialog(context);
        }
        if (current is ResetEmailLoadingState ||
            current is ResetEmailFailState ||
            current is ResetEmailSuccessState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Stack(
            children: [
              Image.asset(
                'images/top_corner.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).width * .44),
                    child: Text(
                      'Forget Password ',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'Please enter your email that we will send \nto it the otp code',
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: EdgeInsets.only(left: 20, right: 20),
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
                          backgroundColor: _isButtonEnabled
                              ? Theme.of(context).primaryColor
                              : const Color(0xFFEEEEEE),
                          padding: const EdgeInsets.symmetric(vertical: 12)),
                      onPressed: _isButtonEnabled
                          ? () {
                              sendResetEmail(emailController.text);
                              // login();
                            }
                          : null,
                      child: Text(
                        'Send Code',
                        style: _isButtonEnabled
                            ? Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)
                            : Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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

  void sendResetEmail(String email) async {
    // async - await
    if (formKey.currentState?.validate() == false &&
        await checkInternetConnection()) {
      return;
    }
    viewmodel.sendResetEmail(email);
  }
}
