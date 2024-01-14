import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/domain/models/user_model.dart';
import 'package:hatly/ui/login/login_screen_arguments.dart';
import 'package:hatly/ui/register/register_screen_arguments.dart';
import 'package:hatly/ui/register/register_viewmodel.dart';
import 'package:hatly/utils/dialog_utils.dart';

import '../../utils/validation_utils.dart';
import '../components/custom_text_field.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = 'Register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController(text: '');

  var emailController = TextEditingController(text: '');

  var mobileController = TextEditingController(text: '');

  var passwordController = TextEditingController(text: '');

  var passwordConfirmationController = TextEditingController(text: '');

  RegisterViewModel viewModel = RegisterViewModel();
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RegisterScreenArguments;
    var countriesList = args.countriesFlagsDto.countries;
    return BlocConsumer(
      bloc: viewModel,
      buildWhen: (previous, current) {
        if (current is RegisterInitialState) {
          return true;
        }
        return false;
      },
      listenWhen: (previous, current) {
        if (previous is RegisterLoadingState) {
          DialogUtils.hideDialog(context);
        }
        if (current is RegisterLoadingState ||
            current is RegisterSuccessState ||
            current is RegisterFailState) {
          return true;
        }
        return false;
      },
      builder: (context, State) {
        return Container(
          decoration: BoxDecoration(
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
                          height: MediaQuery.of(context).size.height * .23),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: CustomFormField(
                          controller: nameController,
                          label: 'Full Name',
                          hint: 'Enter Your Full Name',
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'please enter full name';
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: CustomFormField(
                          controller: mobileController,
                          label: 'Mobile Number',
                          hint: 'Enter Your Mobile Number',
                          keyboardType: TextInputType.phone,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'please enter mobile number';
                            }
                            if (!ValidationUtils.isValidMobile(text)) {
                              return 'please enter a valid mobile number';
                            }
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: CustomFormField(
                          controller: emailController,
                          label: 'Email Address',
                          hint: 'Enter Your Email',
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
                        margin: const EdgeInsets.only(bottom: 25),
                        child: CustomFormField(
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
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 25),
                        child: CustomFormField(
                          controller: passwordConfirmationController,
                          label: 're password',
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
                            register();
                          },
                          child: Text(
                            'Register',
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
                              'Already have an account? Login',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, LoginScreen.routeName,
                                  arguments: LoginScreenArguments(
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
      listener: (context, state) {
        if (state is RegisterFailState) {
          if (Platform.isIOS) {
            DialogUtils.showDialogIos(
                alertMsg: 'Loading',
                alertContent: state.failMessage,
                context: context);
          } else {
            DialogUtils.showDialogAndroid(
                alertMsg: 'Loading',
                alertContent: state.failMessage,
                context: context);
          }
        } else if (state is RegisterLoadingState) {
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
        } else if (state is RegisterSuccessState) {
          // createUserInDb(
          //     nameController.text,
          //     mobileController.text,
          //     emailController.text,
          //     passwordController.text,
          //     passwordConfirmationController.text);
          print('success');
          Navigator.pushReplacementNamed(context, LoginScreen.routeName,
              arguments: LoginScreenArguments(args.countriesFlagsDto));
        }
      },
    );
  }

  // void createUserInDb(String fullName, String mobileNo, String email,
  //     String password, String rePassword) async {
  //   User user = User(
  //       fullName: fullName,
  //       mobileNo: mobileNo,
  //       email: email,
  //       password: password,
  //       rePassword: rePassword);
  //   viewModel.createUserInDb(user);
  // }

  void register() {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    }

    viewModel.register(
        name: nameController.text,
        email: emailController.text,
        phone: mobileController.text,
        password: passwordController.text);
    // loginViewModel.register(emailController.text, passwordController.text);
  }
}
