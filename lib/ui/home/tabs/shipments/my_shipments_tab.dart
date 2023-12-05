import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:hatly/ui/components/shipment_card%20copy.dart';
import 'package:hatly/ui/home/tabs/shipments/my_shipments_screen_viewmodel.dart';
import 'package:hatly/ui/home/tabs/shipments/shipments_bottom_sheet.dart';
import 'package:intl/intl.dart';

import '../../../../domain/models/item_dto.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/dialog_utils.dart';

class MyShipmentsTab extends StatefulWidget {
  static const String routeName = 'MyShipments';

  MyShipmentsTab({super.key});

  @override
  State<MyShipmentsTab> createState() => _MyShipmentsTabState();
}

class _MyShipmentsTabState extends State<MyShipmentsTab> {
  MyShipmentsScreenViewModel viewModel = MyShipmentsScreenViewModel();
  List<ShipmentDto> shipments = [];
  late String token;
  Image? shipImage;

  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

// Check if the current state is LoggedInState and then access the token
    if (userProvider.state is LoggedInState) {
      LoggedInState loggedInState = userProvider.state as LoggedInState;
      token = loggedInState.token;
      // Now you can use the 'token' variable as needed in your code.
      print('User token: $token');
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
        if (state is CreateShipLoadingState) {
          DialogUtils.getDialog('Loading', state.loadingMessage, context);
        } else if (state is CreateShipFailState) {
          DialogUtils.getDialog('Fail', state.failMessage, context);
        }
      },
      listenWhen: (previous, current) {
        if (previous is CreateShipLoadingState) {
          DialogUtils.hideDialog(context);
        }
        if (current is CreateShipLoadingState ||
            current is CreateShipFailState) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        if (state is CreateShipSuccessState) {
          shipments.add(state.responseDto.shipment!);
          print('ship ${shipments.last.title}');
          // setState(() {});
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text('My Shipments'),
            actions: [
              IconButton(
                onPressed: () => showShipmentBottomSheet(context),
                icon: const Icon(
                  Icons.add,
                ),
              ),
            ],
          ),
          body: shipments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset('images/no_shipments.png'),
                        Text(
                          "You don't have any shipments, press the add button to add a shipment",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: shipments.length,
                  itemBuilder: (context, index) => MyShipmentCard(
                    title: shipments[index].title!,
                    from: shipments[index].from!,
                    to: shipments[index].to!,
                    date: DateFormat('dd MMMM yyyy')
                        .format(shipments[index].expectedDate!),
                    shipImage: base64ToImage(
                        shipments[index].items?.first.photo ?? ''), //
                  ),
                ),
        );
      },
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

  void onError(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        animation: AlwaysStoppedAnimation(BorderSide.strokeAlignInside),
        dismissDirection: DismissDirection.down,
        content: Container(
          padding: EdgeInsets.all(16),
          height: 90,
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Oh! Fail',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                errorMessage,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  void done(
      String fromCountry,
      String fromState,
      String toState,
      String toCountry,
      String date,
      String name,
      String note,
      String bonus,
      List<ItemDto> items) {
    viewModel.create(
        token: token,
        from: fromCountry,
        to: toCountry,
        date: date,
        title: name,
        note: note,
        reward: double.tryParse(bonus),
        items: items);
    print(
        '$name , $note , $fromCountry , $fromState , $toCountry , $toState , $bonus , $date itemWeighttt ${items.first.weight}');
    setState(() {});
    Navigator.of(context).pop();
  }

  void showShipmentBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddShipmentBottomSheet(
        onError: onError,
        done: done,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
}
