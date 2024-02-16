import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ShipmentDealAcceptedBottomSheet extends StatefulWidget {
  const ShipmentDealAcceptedBottomSheet({super.key});

  @override
  State<ShipmentDealAcceptedBottomSheet> createState() =>
      ShipmentDealAcceptedBottomSheetState();
}

class ShipmentDealAcceptedBottomSheetState
    extends State<ShipmentDealAcceptedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Generated code for this successBubble Widget...
            Center(
              child: Image.asset(
                'images/deal_accepted.png',
                width: 280,
                height: 280,
              ).animate(
                effects: [
                  VisibilityEffect(duration: 3.ms),
                  FadeEffect(
                    curve: Curves.easeInOut,
                    delay: 4.ms,
                    duration: 300.ms,
                    begin: 0,
                    end: 1,
                  ),
                  ScaleEffect(
                    curve: Curves.easeInOut,
                    delay: 4.ms,
                    duration: 300.ms,
                    begin: Offset(0.8, 0.8),
                    end: Offset(1, 1),
                  ),
                  MoveEffect(
                    curve: Curves.easeInOut,
                    delay: 4.ms,
                    duration: 300.ms,
                    begin: Offset(0, 40),
                    end: Offset(0, 0),
                  ),
                ],
              ).animate(
                effects: [
                  VisibilityEffect(duration: 3.ms),
                  FadeEffect(
                    curve: Curves.easeInOut,
                    delay: 0.ms,
                    duration: 300.ms,
                    begin: 0,
                    end: 1,
                  ),
                  ScaleEffect(
                    curve: Curves.easeInOut,
                    delay: 2.ms,
                    duration: 300.ms,
                    begin: Offset(0.8, 0.8),
                    end: Offset(1, 1),
                  ),
                  MoveEffect(
                    curve: Curves.easeInOut,
                    delay: 2.ms,
                    duration: 300.ms,
                    begin: Offset(0, 40),
                    end: Offset(0, 0),
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "You have accepted \n this deal",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    textStyle: TextStyle(wordSpacing: 3, letterSpacing: 5),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ).animate(
                effects: [
                  VisibilityEffect(duration: 3.ms),
                  FadeEffect(
                    curve: Curves.easeInOut,
                    delay: 500.ms,
                    duration: 300.ms,
                    begin: 0,
                    end: 1,
                  ),
                  ScaleEffect(
                    curve: Curves.easeInOut,
                    delay: 2.ms,
                    duration: 300.ms,
                    begin: Offset(0.8, 0.8),
                    end: Offset(1, 1),
                  ),
                  MoveEffect(
                    curve: Curves.easeInOut,
                    delay: 2.ms,
                    duration: 300.ms,
                    begin: Offset(0, 40),
                    end: Offset(0, 0),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.info),
                  Container(
                    width: MediaQuery.sizeOf(context).width * .85,
                    child: Text(
                      "You will be redirected to the stripe payment screen to pay",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                          // textStyle: TextStyle(wordSpacing: 3, letterSpacing: 5),
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor),
                    ).animate(
                      effects: [
                        VisibilityEffect(duration: 3.ms),
                        FadeEffect(
                          curve: Curves.easeInOut,
                          delay: 500.ms,
                          duration: 300.ms,
                          begin: 0,
                          end: 1,
                        ),
                        ScaleEffect(
                          curve: Curves.easeInOut,
                          delay: 2.ms,
                          duration: 300.ms,
                          begin: Offset(0.8, 0.8),
                          end: Offset(1, 1),
                        ),
                        MoveEffect(
                          curve: Curves.easeInOut,
                          delay: 2.ms,
                          duration: 300.ms,
                          begin: Offset(0, 40),
                          end: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
