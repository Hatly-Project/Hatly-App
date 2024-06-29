import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/home/tabs/forget_password/create_password.dart';
import 'package:hatly/presentation/login/login_screen.dart';
import 'package:hatly/utils/validation_utils.dart';

class ForgetPasswordOtpScreen extends StatefulWidget {
  static const routeName = 'forgetPasswordOtp';
  const ForgetPasswordOtpScreen({super.key});

  @override
  State<ForgetPasswordOtpScreen> createState() =>
      _ForgetPasswordOtpScreenState();
}

class _ForgetPasswordOtpScreenState extends State<ForgetPasswordOtpScreen> {
  var formKey = GlobalKey<FormState>();

  var firstController = TextEditingController(text: '');
  var secondController = TextEditingController(text: '');
  var thirdController = TextEditingController(text: '');
  var fourthController = TextEditingController(text: '');

  bool _isButtonEnabled = false,
      _isFirstEnabled = false,
      _isSecondEnabled = false,
      _isThirdEnabled = false,
      _isFourthEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firstController.addListener(_checkFormCompletion);
    secondController.addListener(_checkFormCompletion);
    thirdController.addListener(_checkFormCompletion);
    fourthController.addListener(_checkFormCompletion);
  }

  void _checkFormCompletion() {
    // Check if both fields are non-empty
    if (firstController.text.trim().isNotEmpty &&
        secondController.text.trim().isNotEmpty &&
        thirdController.text.trim().isNotEmpty &&
        fourthController.text.trim().isNotEmpty) {
      // if (firstController.text.trim().isNotEmpty) {
      //   _isFirstEnabled = true;
      // } else if (secondController.text.trim().isNotEmpty) {
      //   _isSecondEnabled = true;
      // } else if (thirdController.text.trim().isNotEmpty) {
      //   _isThirdEnabled = true;
      // } else {
      //   _isFourthEnabled = true;
      // }
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
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Form(
                    key: formKey,
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              height: 70,
                              width: 85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: _isFirstEnabled
                                        ? Color(0xFF424242)
                                        : Color(0xFFD6D6D6)),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: firstController,
                                  onChanged: (value) {
                                    _isFirstEnabled = !_isFirstEnabled;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      counterText: '',
                                      isCollapsed: true,
                                      border: InputBorder.none),
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              height: 70,
                              width: 85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: _isSecondEnabled
                                        ? Color(0xFF424242)
                                        : Color(0xFFD6D6D6)),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: secondController,
                                  onChanged: (value) {
                                    _isSecondEnabled = !_isSecondEnabled;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      counterText: '',
                                      isCollapsed: true,
                                      border: InputBorder.none),
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              height: 70,
                              width: 85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: _isThirdEnabled
                                        ? Color(0xFF424242)
                                        : Color(0xFFD6D6D6)),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: thirdController,
                                  onChanged: (value) {
                                    _isThirdEnabled = !_isThirdEnabled;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      counterText: '',
                                      isCollapsed: true,
                                      border: InputBorder.none),
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              height: 70,
                              width: 85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: _isFourthEnabled
                                        ? Color(0xFF424242)
                                        : Color(0xFFD6D6D6)),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: fourthController,
                                  onChanged: (value) {
                                    _isFourthEnabled = !_isFourthEnabled;
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                      counterText: '',
                                      isCollapsed: true,
                                      border: InputBorder.none),
                                  maxLength: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
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
                          Navigator.pushReplacementNamed(
                              context, CreatePasswordScreen.routeName);
                          // login();
                        }
                      : null,
                  child: Text(
                    'Verify',
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
}
