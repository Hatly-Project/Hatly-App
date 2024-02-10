import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/deal_dto.dart';
import 'package:hatly/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class MyShipmentDealCard extends StatefulWidget {
  DealDto dealDto;
  MyShipmentDealCard({required this.dealDto});

  @override
  State<MyShipmentDealCard> createState() => _MyShipmentDealCardState();
}

class _MyShipmentDealCardState extends State<MyShipmentDealCard> {
  late LoggedInState loggedInState;
  late String userEmail;
  @override
  void initState() {
    super.initState();

    UserProvider userProvider =
        BlocProvider.of<UserProvider>(context, listen: false);

    if (userProvider.state is LoggedInState) {
      loggedInState = userProvider.state as LoggedInState;
      userEmail = loggedInState.user.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, TripDetails.routeName,
          //   arguments: TripDetailsArguments(tripsDto: tripsDto));
        },
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          child: Column(
            children: [
              if (widget.dealDto.creatorEmail != userEmail)
                Container(
                  // margin: EdgeInsets.only(top: 5),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .045,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.amber),
                  child: Center(
                    child: Text(
                      'An offer from traveller ${widget.dealDto.traveler?.name}',
                      // textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            widget.dealDto.trip!.origin!,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Expanded(
                          child: Icon(
                            Icons.flight_land_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              widget.dealDto.trip!.destination ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Departs At ${DateFormat('dd MMMM yyyy').format(widget.dealDto.trip!.departDate!)}',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'images/bag.png',
                              width: 15,
                              height: 50,
                              filterQuality: FilterQuality.high,
                            ),
                            Text(
                              '${widget.dealDto.trip!.available!.toString()} Available Kg',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'images/bag.png',
                              width: 15,
                              height: 50,
                              filterQuality: FilterQuality.high,
                            ),
                            Text(
                              '${widget.dealDto.trip!.consumed!.toString()} Consumed Kg',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      height: 2,
                      thickness: 2,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: widget.dealDto.traveler!.profilePhoto ==
                                        null
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        color: Colors.grey[300],
                                      )
                                    : Image.network(
                                        widget.dealDto.traveler!.profilePhoto,
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                      )),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dealDto.traveler!.name!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                Text(
                                  '4.3 Reviews',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .045,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Theme.of(context).primaryColor),
                child: Center(
                  child: Text(
                    'Shipping Bonus ${widget.dealDto.reward} \$',
                    // textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
