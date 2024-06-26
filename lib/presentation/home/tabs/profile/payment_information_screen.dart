import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/home/tabs/profile/payment_inforamtion_screen_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/profile/routing_number_bottom_sheet.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

class PaymentInformationScreen extends StatefulWidget {
  static const String routeName = 'PaymentInfo';
  const PaymentInformationScreen({super.key});

  @override
  State<PaymentInformationScreen> createState() =>
      _PaymentInformationScreenState();
}

class _PaymentInformationScreenState extends State<PaymentInformationScreen> {
  var formKey = GlobalKey<FormState>();
  var accountNumberController = TextEditingController(text: '');
  var siwftNumberController = TextEditingController(text: null);
  var accountNameController = TextEditingController(text: '');
  var accountCurrencyController = TextEditingController(text: '');
  var accountCountryController = TextEditingController(text: '');
  late PaymentInformationScreenViewModel viewModel;
  late AccessTokenProvider accessTokenProvider;
  late int? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // accessTokenProvider =
    //     Provider.of<AccessTokenProvider>(context, listen: false);
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = PaymentInformationScreenViewModel(accessTokenProvider);
    // Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      // userId = loggedInState.user.id;
      print('user iDDD $userId');
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
    return BlocConsumer(
        bloc: viewModel,
        listener: (context, state) {
          if (state is UpdatePaymentInfoLoadingState) {
            isLoading = true;
          } else if (state is UpdatePaymentInfoFailState) {
            if (Platform.isIOS) {
              DialogUtils.showDialogIos(
                  context: context,
                  alertMsg: 'Fail',
                  alertContent: state.failMessage);
            } else {
              DialogUtils.showDialogAndroid(
                  alertMsg: 'Fail',
                  alertContent: state.failMessage,
                  context: context);
            }
          }
        },
        listenWhen: (previous, current) {
          if (previous is UpdatePaymentInfoLoadingState) {
            isLoading = false;
          }
          if (current is UpdatePaymentInfoLoadingState ||
              current is UpdatePaymentInfoSuccessState ||
              current is UpdatePaymentInfoFailState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is UpdatePaymentInfoSuccessState) {
            isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          }
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    'Payment Information',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.info),
                              Text(
                                  'Please make sure to provide accurate information')
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomFormField(
                            controller: accountNumberController,
                            hint: 'Enter Your IBAN Or Account Number ',
                            maxLength: 34,
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter account number';
                              }
                              if (!(text.trim().length >= 5 &&
                                  text.trim().length <= 34)) {
                                return 'account number not valid';
                              }
                            },
                          ),
                          CustomFormField(
                            controller: siwftNumberController,
                            hint: 'Enter Your SWIFT Code',
                            keyboardType: TextInputType.text,
                            maxLength: 11,
                            suffixICon: InkWell(
                              onTap: () {
                                _showRoutingNumberInfoBottomSheet(context);
                              },
                              child: Icon(Icons.info),
                            ),
                          ),
                          CustomFormField(
                            controller: accountNameController,
                            hint: 'Enter Your Account Name',
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter account name';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomFormField(
                            controller: accountCurrencyController,
                            hint: 'Enter Your Account Currency',
                            keyboardType: TextInputType.text,
                            maxLength: 3,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter account currency';
                              }
                            },
                          ),
                          CustomFormField(
                            controller: accountCountryController,
                            hint: 'Enter Your Account Country',
                            keyboardType: TextInputType.text,
                            maxLength: 2,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter account country';
                              }
                            },
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      MediaQuery.sizeOf(context).width, 60),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  side: BorderSide(
                                      color: Colors.grey[600]!, width: 1),
                                  backgroundColor: Colors.transparent,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12)),
                              onPressed: () {
                                if (formKey.currentState?.validate() == false) {
                                  return;
                                }
                                viewModel.updatePaymentInfo(
                                  accountNumber: accountNumberController.text,
                                  accountName: accountNameController.text,
                                  accountCountry: accountCountryController.text,
                                  accountCurrency:
                                      accountCurrencyController.text,
                                  routingNumber: siwftNumberController.text,
                                  userid: userId,
                                );
                                // login();
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Platform.isIOS
                          ? const CupertinoActivityIndicator(
                              radius: 25,
                              color: Colors.black,
                            )
                          : const CircularProgressIndicator(
                              color: Colors.black,
                            ),
                    ),
                  ),
                ),
            ],
          );
        });
  }

  void _showRoutingNumberInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) => RoutingNumberBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
