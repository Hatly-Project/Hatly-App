import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../utils/validation_utils.dart';
import '../components/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = 'Login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController(text: '');

  var passwordController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/firstBack.png'), fit: BoxFit.cover)),
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
                    Text(
                      'Welcome Back To Hatly',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        'Please sign in with your email and password',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
                            padding: const EdgeInsets.symmetric(vertical: 12)),
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
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(
                            //     context, RegisterScreen.routeName);
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
      ),
    );
  }

  void login() async {
    // async - await
    if (formKey.currentState?.validate() == false) {
      return;
    }
    // loginViewModel.login(emailController.text, passwordController.text);
  }
}
