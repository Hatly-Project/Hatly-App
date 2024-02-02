import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyShipmentDeals extends StatefulWidget {
  const MyShipmentDeals({super.key});

  @override
  State<MyShipmentDeals> createState() => _ShipmentDealsState();
}

class _ShipmentDealsState extends State<MyShipmentDeals> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // CupertinoSliverRefreshControl(
          //   onRefresh: () async {
          //     await viewModel.getMyShipments(token: token);
          //     cacheMyShipments(myShipments);
          //     setState(() {});
          //   },
          // ),
          // shimmerIsLoading
          //     ?
          //     SliverList(
          //         delegate: SliverChildBuilderDelegate(
          //             (context, index) => MyShipmentShimmerCard(),
          //             childCount: 5),
          //       )
          // : isMyshipmentEmpty
          //     ?
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).width * .25),
                    child: Image.asset('images/no_deals.png'),
                  ),
                  Text(
                    "You don't have any deals for this shipment",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
          // : SliverList(
          //     delegate: SliverChildBuilderDelegate(
          //         (context, index) => MyShipmentCard(
          //               title: myShipments[index].title!,
          //               from: myShipments[index].from!,
          //               to: myShipments[index].to!,
          //               date: DateFormat('dd MMMM yyyy')
          //                   .format(myShipments[index]
          //                       .expectedDate!),
          //               shipImage: Image.network(
          //                 myShipments[index]
          //                     .items!
          //                     .first
          //                     .photos!
          //                     .first
          //                     .photo!,
          //                 fit: BoxFit.fitHeight,
          //                 width: 100,
          //                 height: 100,
          //               ), //
          //             ),
          //         childCount: myShipments.length),
          //   ),
        ],
      ),
    );
  }
}
