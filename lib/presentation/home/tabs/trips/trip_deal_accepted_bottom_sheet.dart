import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class TripDealAcceptedBottomSheet extends StatefulWidget {
  const TripDealAcceptedBottomSheet({super.key});

  @override
  State<TripDealAcceptedBottomSheet> createState() =>
      _DealConfirmedBottomSheetState();
}

class _DealConfirmedBottomSheetState
    extends State<TripDealAcceptedBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Generated code for this successBubble Widget...
          Align(
            alignment: AlignmentDirectional(0, -1),
            child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 44, 0, 0),
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Color(0xFFc2f1ec),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF9ae7df),
                      width: 4,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color(0xFF3ad2c0),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF3ad2c0),
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 70,
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
                      ),
                    ),
                  ),
                )
                // .animateOnPageLoad(
                //     animationsMap['containerOnPageLoadAnimation']!),
                ),
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

          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "The deal has \n been accepted successfully",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 30,
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
        ],
      ),
    );
  }
}
