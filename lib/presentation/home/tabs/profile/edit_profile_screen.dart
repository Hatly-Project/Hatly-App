import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/presentation/components/countries_list_bottom_sheet.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/home/tabs/profile/edit_profile_screen_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/profile/payment_inforamtion_screen_viewmodel.dart';
import 'package:hatly/presentation/home/tabs/profile/profile_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/profile/routing_number_bottom_sheet.dart';
import 'package:hatly/providers/access_token_provider.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = 'EditProfile';
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var formKey = GlobalKey<FormState>();
  var addressController = TextEditingController(text: '');
  var cityController = TextEditingController(text: '');
  var postalCodeController = TextEditingController(text: '');
  var countryController = TextEditingController(text: '');
  var phoneController = TextEditingController(text: '');
  String? dialCode;
  String? countryImageUrl, ipAddress;

  late EditProfileScreenViewModel viewModel;
  late AccessTokenProvider accessTokenProvider;
  late int? userId;
  bool isLoading = false;
  var dateController = TextEditingController(text: '');
  String date = '';
  late ProfileScreenArguments args;
  @override
  void initState() {
    super.initState();
    // accessTokenProvider =
    //     Provider.of<AccessTokenProvider>(context, listen: false);
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);
    accessTokenProvider =
        Provider.of<AccessTokenProvider>(context, listen: false);
    viewModel = EditProfileScreenViewModel(accessTokenProvider);
    // Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      userId = loggedInState.user.id;
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
    args = ModalRoute.of(context)!.settings.arguments as ProfileScreenArguments;

    return BlocConsumer(
        bloc: viewModel,
        listener: (context, state) {
          if (state is UpdateProfileLoadingState) {
            isLoading = true;
          } else if (state is UpdateProfileFailState) {
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
          if (previous is UpdateProfileLoadingState) {
            isLoading = false;
          }
          if (current is UpdateProfileLoadingState ||
              current is UpdateProfileSuccessState ||
              current is UpdateProfileFailState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is UpdateProfileSuccessState) {
            isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop();
            });
          }
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  elevation: 0,
                  shadowColor: Colors.white,
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  title: Text(
                    'Edit Profile',
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
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFF30B2A3), width: 2.5),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.asset(
                                    'images/me.jpg',
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomFormField(
                            controller: dateController,
                            hint: 'Enter Your Date Of Birth ',
                            maxLength: 34,
                            // onTap: () {
                            //   _selectDate(context);
                            // },
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter date of birth';
                              }
                              return null;
                            },
                          ),
                          CustomFormField(
                            controller: addressController,
                            hint: 'Enter Your Street Address',
                            keyboardType: TextInputType.text,
                            maxLength: 25,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter street address';
                              }
                              return null;
                            },
                          ),
                          CustomFormField(
                            controller: cityController,
                            hint: 'Enter Your City',
                            keyboardType: TextInputType.text,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter your city';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomFormField(
                            controller: countryController,
                            hint: 'Enter Your Account Country',
                            keyboardType: TextInputType.text,
                            onTap: () {
                              showCountriesListBottomSheet(
                                  context, args.countriesFlagsDto);
                            },
                            maxLength: 2,
                            readOnly: true,
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter account country';
                              }
                            },
                          ),
                          CustomFormField(
                            controller: postalCodeController,
                            hint: 'Enter Your Postal Code',
                            keyboardType: TextInputType.text,
                            // readOnly: true,
                            maxLength: 10,
                            // onTap: () {
                            //   showCurrenciesListBottomSheet(
                            //       context, args.countriesFlagsDto);
                            // },
                            validator: (text) {
                              if (text?.trim() == null ||
                                  text!.trim().isEmpty) {
                                return 'please enter postal code';
                              }
                              return null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    showPhoneCodesBottomSheet(
                                        context, args.countriesFlagsDto);
                                  },
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              countryImageUrl ??
                                                  args.countriesFlagsDto
                                                      .countries!
                                                      .firstWhere((country) =>
                                                          country.name
                                                              ?.toLowerCase() ==
                                                          'Egypt'.toLowerCase())
                                                      .flag!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                .07,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                dialCode ??
                                                    args.countriesFlagsDto
                                                        .countries!
                                                        .firstWhere((country) =>
                                                            country.name
                                                                ?.toLowerCase() ==
                                                            'Egypt'
                                                                .toLowerCase())
                                                        .dialCode!,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_drop_down_rounded,
                                            size: 33,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * .6,
                                child: CustomFormField(
                                  controller: phoneController,
                                  hint: 'Enter Your Mobile Number',
                                  keyboardType: TextInputType.text,
                                  onTap: () {
                                    // showCountriesListBottomSheet(
                                    //     context, args.countriesFlagsDto);
                                  },
                                  // maxLength: 2,
                                  // readOnly: true,
                                  validator: (text) {
                                    if (text?.trim() == null ||
                                        text!.trim().isEmpty) {
                                      return 'please enter your mobile number';
                                    }
                                  },
                                ),
                              ),
                            ],
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
                              onPressed: () async {
                                if (formKey.currentState?.validate() == false) {
                                  return;
                                }

                                if (accessTokenProvider.accessToken != null) {
                                  viewModel.updateProfile(
                                      accessToken:
                                          accessTokenProvider.accessToken,
                                      dob: dateController.text,
                                      city: cityController.text,
                                      country: countryController.text,
                                      address: addressController.text,
                                      postalCode: postalCodeController.text,
                                      phone: '$dialCode${phoneController.text}',
                                      ip: await getIpAddress());
                                }
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

  Future<String?> getIpAddress() async {
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
            return ipAddress;
          }
        }
      }
    } catch (e) {
      print('Error getting IP address: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    if (Platform.isIOS) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                  final formattedDate = DateFormat('yyyy-MM-dd')
                      .format(selectedDate); // Format the date
                  // final time = TimeOfDay.fromDateTime(selectedDate);
                  // Format the date
                  // var formattedTime = time.format(context);
                  dateController.text = formattedDate;

                  date = dateController.text;

                  //                   final formattedDate = TimeOfDay.fromDateTime(selectedDate);
                  // // Format the date
                  // dateController.text = formattedDate.format(context);
                });
              },
            ),
          );
        },
      );
    } else if (Platform.isAndroid) {
      var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          final formattedDate = DateFormat('dd MMMM yyyy')
              .format(selectedDate); // Format the date
          final time = TimeOfDay.fromDateTime(selectedDate);
          // Format the date
          var formattedTime = time.format(context);
          dateController.text = '${formattedDate + ' ' + formattedTime}';

          date = selectedDate.toIso8601String();
        });
      }
    }
  }

  void setCurrecnyText(String currency) {
    Navigator.pop(context);
    postalCodeController.text = currency;
    setState(() {});
  }

  void setCountryText(String country) {
    Navigator.pop(context);
    countryController.text = country;
    setState(() {});
  }

  void setPhoneCode(CountriesStatesDto country) {
    Navigator.pop(context);
    dialCode = country.dialCode!;
    countryImageUrl = country.flag;
    setState(() {});
  }

  void showCurrenciesListBottomSheet(
      BuildContext context, CountriesDto countries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => CountriesListBottomSheet(
        countries: countries,
        selectCurrency: setCurrecnyText,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void showPhoneCodesBottomSheet(BuildContext context, CountriesDto countries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => CountriesListBottomSheet(
        countries: countries,
        selectCode: setPhoneCode,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void showCountriesListBottomSheet(
      BuildContext context, CountriesDto countries) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => CountriesListBottomSheet(
        countries: countries,
        selectCountry: setCountryText,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
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
