import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/state_dto.dart';
import 'package:hatly/ui/components/country_flag_card.dart';
import 'package:hatly/ui/components/state_card.dart';

class StatesListBottomSheet extends StatefulWidget {
  List<StateDto> states;
  Function? selectFromCity, selectToCity;
  StatesListBottomSheet(
      {required this.states, this.selectFromCity, this.selectToCity});

  @override
  State<StatesListBottomSheet> createState() =>
      _CountriesListBottomSheetState();
}

class _CountriesListBottomSheetState extends State<StatesListBottomSheet> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        controller: scrollController,
        itemCount: widget.states.length,
        itemBuilder: (context, index) => StateCard(
          stateName: widget.states[index].name!,
          selectFromCity: widget.selectFromCity,
          selectToCity: widget.selectToCity,
        ),
      ),
    );
  }
}
