import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_deals.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/my_shipment_details_screen-viewmodel.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:hatly/utils/dialog_utils.dart';

class MyShipmentDetails extends StatefulWidget {
  static const routeName = 'MyShipmentDetails';
  const MyShipmentDetails({super.key});

  @override
  State<MyShipmentDetails> createState() => _MyShipmentDetailsState();
}

class _MyShipmentDetailsState extends State<MyShipmentDetails> {
  late LoggedInState loggedInState;
  MyShipmentDetailsScreenViewModel viewModel =
      MyShipmentDetailsScreenViewModel();

  List<DealDto>? deals;
  bool isMyshipmentDealsEmpty = false;
  late String token;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      token = loggedInState.accessToken;
      // Now you can use the 'token' variable as needed in your code.
      print('User token: $token');
      print('user email ${loggedInState.user.email}');
    } else {
      print(
          'User is not logged in.'); // Handle the scenario where the user is not logged in.
    }

    // getMyshipmentDeals(token: token, shipmentId: shipmentId)

    // Check for cached shipments when initializing
    // getCachedMyShipments().then((cachedShipments) async {
    //   if (cachedShipments.isNotEmpty) {
    //     print('exist');
    //     setState(() {
    //       myShipments = cachedShipments;
    //     });
    //   } else {
    //     await viewModel.getMyShipments(token: token);
    //     print('no Exist'); // Fetch from API if cache is empty
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments
        as MyShipmentDetailsArguments;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            args.shipmentDto.title!,
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Deals',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Matching Trips',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    'Shipment Info',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () => Navigator.pop(context),
          //     icon: const Icon(
          //       Icons.add,
          //       color: Colors.white,
          //     ),
          //   ),
          // ],
        ),
        body: TabBarView(
          children: [
            MyShipmentDeals(
              shipmentDto: args.shipmentDto,
            ),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
