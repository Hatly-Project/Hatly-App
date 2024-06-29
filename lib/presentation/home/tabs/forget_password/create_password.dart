import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/home/tabs/forget_password/forget_password_code_screen.dart';
import 'package:hatly/utils/validation_utils.dart';

class CreatePasswordScreen extends StatefulWidget {
  static const routeName = 'createPassword';
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  var formKey = GlobalKey<FormState>();
  var connectivityResult;

  var passwordController = TextEditingController(text: '');
  var rePasswordController = TextEditingController(text: '');

  bool _isButtonEnabled = false, _obscurePassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    passwordController.addListener(_checkFormCompletion);
    rePasswordController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    // Check if both fields are non-empty
    if (passwordController.text.trim().isNotEmpty &&
        rePasswordController.text.trim().isNotEmpty) {
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
                  'Reset Password ',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'Create a new password that you can \nremember',
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
                        controller: passwordController,
                        label: null,
                        hint: 'Password',
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please enter password';
                          }
                          if (!ValidationUtils.isValidPassword(text)) {
                            return 'Password must be more than 8 characters ';
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: CustomFormField(
                        controller: rePasswordController,
                        label: null,
                        hint: 'Re Password',
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'Please re enter the password';
                          }
                          if (!ValidationUtils.isValidPassword(text)) {
                            return 'Password must be more than 8 characters ';
                          }
                          if (passwordController.text !=
                              rePasswordController.text) {
                            return 'Password does not match';
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
                          submit();
                          // login();
                        }
                      : null,
                  child: Text(
                    'Confirm',
                    style: _isButtonEnabled
                        ? Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: Theme.of(context).scaffoldBackgroundColor,
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

  void submit() async {
    // async - await
    if (formKey.currentState?.validate() == false &&
        await checkInternetConnection()) {
      return;
    }
    // Navigator.pushReplacementNamed(context, ForgetPasswordOtpScreen.routeName);
    // viewModel.login(passwordController.text, passwordController.text);
  }
}
