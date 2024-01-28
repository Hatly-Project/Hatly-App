import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class StateCard extends StatelessWidget {
  String stateName = '';
  Function? selectFromCity, selectToCity;
  StateCard({required this.stateName, this.selectFromCity, this.selectToCity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (selectFromCity == null) {
            selectedToCity(selectToCity!);
          } else {
            selectedFromCity(selectFromCity!);
          }
        },
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .1,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * .50,
                child: Text(
                  stateName,
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectedFromCity(Function select) {
    select(stateName);
  }

  void selectedToCity(Function select) {
    select(stateName);
  }
}
