import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/state_dto.dart';
import 'package:hatly/presentation/components/country_flag_card.dart';
import 'package:hatly/presentation/components/state_card.dart';

class StatesList extends StatefulWidget {
  List<StateDto> stateDto;
  // Function? selectCurrency, selectCountry, selectCode;
  Function? selectFromState, selectToState;
  Function? hideOverLay;
  StatesList({
    required this.stateDto,
    this.hideOverLay,
    this.selectToState,
    this.selectFromState,
  });

  @override
  State<StatesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<StatesList> {
  ScrollController scrollController = ScrollController();
  List<StateDto> filteredStates = [];
  @override
  void initState() {
    super.initState();
    filteredStates.addAll(widget.stateDto);
  }

  void filterList(String query) {
    filteredStates.clear();
    if (query.isNotEmpty) {
      if (widget.selectFromState != null || widget.selectToState != null) {
        widget.stateDto.forEach((state) {
          if (state.name!.toLowerCase().startsWith(query.toLowerCase())) {
            filteredStates.add(state);
          }
        });
      }
    } else {
      filteredStates.addAll(widget.stateDto);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: Material(
          elevation: 4.0,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterList(value);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFEEEEEE), width: 2),
                    ),
                    labelText: 'Search',
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 5, bottom: 5),
                    child: Container(
                      // margin: EdgeInsets.only(top: 10),
                      width: double.infinity,
                      height: 1,
                      color: Color(0xFFEEEEEE),
                    ),
                  ),
                  controller: scrollController,
                  itemCount: filteredStates.length,
                  itemBuilder: (context, index) => StateCard(
                    stateName: filteredStates[index].name!,
                    selectFromCity: widget.selectFromState,
                    selectToCity: widget.selectToState,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
