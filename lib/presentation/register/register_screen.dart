import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/domain/models/user_model.dart';
import 'package:hatly/presentation/login/login_screen_arguments.dart';
import 'package:hatly/presentation/register/register_screen_arguments.dart';
import 'package:hatly/presentation/register/register_viewmodel.dart';
import 'package:hatly/providers/access_token_provider.dart';
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
  String? fcmToken = '';
  String ipAddress = '';
  bool _isButtonEnabled = false, _obsecurePassword = false;
  var formKey = GlobalKey<FormState>();

  var fullNameController = TextEditingController(text: '');

  var emailController = TextEditingController(text: '');

  var passwordController = TextEditingController(text: '');

  late RegisterViewModel viewModel;
  @override
  void initState() {
    super.initState();

    getIpAddress();
    getFcmToken().then((value) {
      fcmToken = value;
    });
    print('fcm token $fcmToken');

    fullNameController.addListener(_checkFormCompletion);

    emailController.addListener(_checkFormCompletion);

    passwordController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    // Check if both fields are non-empty
    if (fullNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }

  Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  void getIpAddress() async {
    try {
      // Get the list of network interfaces
      List<NetworkInterface> interfaces = await NetworkInterface.list(
          includeLinkLocal: true, includeLoopback: true);

      // Iterate through the interfaces to find the IP address
      for (NetworkInterface interface in interfaces) {
        for (InternetAddress address in interface.addresses) {
          // Check if the address is an IPv4 address
          if (address.type == InternetAddressType.IPv4) {
            ipAddress = address.address;
            print('IP Address: $ipAddress');
            return;
          }
        }
      }
    } catch (e) {
      print('Error getting IP address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RegisterScreenArguments;
    var accessTokenProvider = context.read<AccessTokenProvider>();
    viewModel = RegisterViewModel(accessTokenProvider: accessTokenProvider);
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
        return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: Stack(
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
                        child: Text(
                          'Let’s get started',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          'Please enter the required data to create \nyour account',
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: CustomFormField(
                              controller: fullNameController,
                              label: null,
                              hint: 'Full Name',
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'please enter full name';
                                }
                                if (!ValidationUtils.isValidFullName(text)) {
                                  return 'please enter a valid full name';
                                }
                              },
                            ),
                          ),
                          Container(
                            // margin: const EdgeInsets.only(top: 15),
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 12),
                            child: CustomFormField(
                              controller: emailController,
                              label: null,
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
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 15),
                            child: CustomFormField(
                              controller: passwordController,
                              label: null,
                              hint: 'Password',
                              keyboardType: TextInputType.text,
                              isPassword: _obsecurePassword,
                              suffixICon: IconButton(
                                icon: _obsecurePassword
                                    ? const Icon(
                                        Icons.visibility_off_outlined,
                                      )
                                    : const Icon(
                                        Icons.visibility_outlined,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _obsecurePassword = !_obsecurePassword;
                                  });
                                },
                              ),
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'please enter password';
                                }
                                if (!ValidationUtils.isValidPassword(text)) {
                                  return 'Password must be more than 8 characters';
                                }
                              },
                            ),
                          ),
                        ],
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12)),
                          onPressed: _isButtonEnabled
                              ? () {
                                  register();
                                }
                              : null,
                          child: Text(
                            'Create Account',
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
                              ' or Create Account With... ',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12)),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12)),
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
              ),
            ));
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
    var fullNameSplitted = fullNameController.text.split(' ');
    viewModel.register(
        firstName: fullNameSplitted.first,
        lastName: fullNameSplitted.last,
        email: emailController.text,
        ip: ipAddress,
        password: passwordController.text,
        fcmToken: fcmToken);
  }
}
