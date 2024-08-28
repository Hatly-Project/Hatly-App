import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/domain/models/trips_dto.dart';
import 'package:hatly/my_theme.dart';
import 'package:hatly/presentation/components/item_card.dart';
import 'package:hatly/presentation/components/shipment_details_card.dart';
import 'package:hatly/presentation/components/shopping_items_card.dart';
import 'package:hatly/presentation/home/bottom_nav_icon.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipment_deal_confirmed_bottom_sheet.dart';
import 'package:hatly/presentation/home/tabs/shipments/shipments_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/trips_list_bottom_sheet.dart';
import 'package:hatly/providers/auth_provider.dart';

class ShipmentDetails extends StatefulWidget {
  String? shipmentTitle;
  static const routeName = 'ShipmentDetails';

  ShipmentDetails({this.shipmentTitle});

  @override
  State<ShipmentDetails> createState() => _ShipmentDetailsState();
}

class _ShipmentDetailsState extends State<ShipmentDetails> {
  ScrollController scrollController = ScrollController();

  var selectedIndex = 0;

  var isSelected = false;
  final GlobalKey key = GlobalKey();
  double _listViewHeight = 0.0;
  late String fromCountryFlag,
      toCountryFlag,
      fromCountryName,
      toCountryName,
      userFirstName,
      userLastName,
      userProfilePhoto;
  late List<CountriesStatesDto> countriesStatesDto;
  late ShipmentDto shipmentDto;
  late int shoppingItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      userFirstName = loggedInState.user.firstName!;
      userLastName = loggedInState.user.lastName!;
      userProfilePhoto = loggedInState.user.profilePhoto ?? '';
      // token = loggedInState.accessToken;
      // Now you can use the 'token' variable as needed in your code.
      // getAccessToken(accessTokenProvider);
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as ShipmentDetailsArguments;
    shipmentDto = args.shipmentDto;
    shoppingItems = shipmentDto.items!.length;
    countriesStatesDto = args.countriesStatesDto!;

    fromCountryFlag = countriesStatesDto[countriesStatesDto
            .indexWhere((country) => country.iso2 == shipmentDto.from)]
        .flag!;

    fromCountryName = countriesStatesDto[countriesStatesDto
            .indexWhere((country) => country.iso2 == shipmentDto.from)]
        .name!;

    toCountryFlag = countriesStatesDto[countriesStatesDto
            .indexWhere((country) => country.iso2 == shipmentDto.to)]
        .flag!;
    toCountryName = countriesStatesDto[countriesStatesDto
            .indexWhere((country) => country.iso2 == shipmentDto.to)]
        .name!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        title: Text(
          shipmentDto.title!,
          style:
              Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShipmentDetailsCard(
              fromCountryFlag: fromCountryFlag,
              fromCountryName: fromCountryName,
              toCountryFlag: toCountryFlag,
              toCountryName: toCountryName,
              shipmentDto: shipmentDto,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Posted by',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 17),
                textScaler: TextScaler.noScaling,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              'images/me.jpg',
                              fit: BoxFit.cover,
                              width: 35,
                              height: 35,
                            ),
                          ),
                          Text(
                            ' $userFirstName $userLastName',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                    fontSize: 18, color: Color(0xFF5A5A5A)),
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: MyTheme.iconColor,
                        size: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'Items',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 17),
                textScaler: TextScaler.noScaling,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              height: 195,
              child: ListView.builder(
                itemCount: shipmentDto.items!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => ItemCard(
                  shipmentDto: shipmentDto,
                  index: index,
                  onHeightCalculated: (height) {
                    setState(() {
                      _listViewHeight = height;
                      print('height $_listViewHeight');
                    });
                  },
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () async {
                  // login();
                },
                child: Text(
                  'Send Offer',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(String successMsg) {
    _showShipmentDealConfirmedBottomSheet(context);
    // if (Platform.isIOS) {
    //   DialogUtils.showDialogIos(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // } else {
    //   DialogUtils.showDialogAndroid(
    //       alertMsg: 'Success', alertContent: successMsg, context: context);
    // }
  }

  void _showShipmentDealConfirmedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      builder: (context) => DealConfirmedBottomSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  void _showTripsListBottomSheet(BuildContext context,
      Function showSuccessDialog, ShipmentDto shipmentDto) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => TripsListBottomSheet(
        showSuccessDialog: showSuccessDialog,
        shipmentDto: shipmentDto,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  Image base64ToImage(String base64String) {
    Uint8List bytes = base64.decode(base64String);
    return Image.memory(
      bytes,
      fit: BoxFit.fitHeight,
      width: 100,
      height: 100,
    );
  }
}
