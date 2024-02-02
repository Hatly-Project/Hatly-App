import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/presentation/components/deals_widget.dart';

class MyShipmentDetails extends StatefulWidget {
  static const routeName = 'MyShipmentDetails';
  const MyShipmentDetails({super.key});

  @override
  State<MyShipmentDetails> createState() => _MyShipmentDetailsState();
}

class _MyShipmentDetailsState extends State<MyShipmentDetails> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Alaa',
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
            MyShipmentDeals(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
