import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/countries_dto.dart';
import 'package:hatly/domain/models/country_dto.dart';
import 'package:hatly/domain/models/state_dto.dart';
import 'package:hatly/presentation/components/button_widget.dart';
import 'package:hatly/presentation/components/countries_list.dart';
import 'package:hatly/presentation/components/custom_fields_for_search.dart';
import 'package:hatly/presentation/components/custom_text_field.dart';
import 'package:hatly/presentation/components/states_list.dart';
import 'package:intl/intl.dart';

class AddShipmentDetailsTab extends StatefulWidget {
  CountriesDto countriesFlagsDto;
  Function next;
  AddShipmentDetailsTab({required this.countriesFlagsDto, required this.next});

  @override
  State<AddShipmentDetailsTab> createState() => _AddShipmentDetailsTabState();
}

class _AddShipmentDetailsTabState extends State<AddShipmentDetailsTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _statesOverlayEntry;

  final GlobalKey shipmentFromKey = GlobalKey();
  final GlobalKey receivingInKey = GlobalKey();
  // final GlobalKey shipmentCardKey = GlobalKey();

  final GlobalKey shipmentToCountryKey = GlobalKey();
  final GlobalKey shipmentToCityKey = GlobalKey();
  // final GlobalKey shipmentCardKey = GlobalKey();

  bool _isFromCityClicked = false,
      _isToCityClicked = false,
      _isFromCountryClicked = false,
      _isToCountryClicked = false;

  late AnimationController _controller;
  late AnimationController _statesController;

  late Animation<Offset> _animation;
  List<CountriesStatesDto> filteredCountries = [];
  String? fromCountry,
      fromCountryFlag,
      toCountryName,
      toCountryFlag,
      fromCountryIso,
      toCountryIso,
      fromCity,
      toCity,
      date;
  late List<StateDto> fromStatesList, toStatesList;
  bool _isButtonEnabled = false;
  TextEditingController fromController = TextEditingController(text: '');
  TextEditingController fromCityController = TextEditingController(text: '');

  TextEditingController toCountryController = TextEditingController(text: '');
  TextEditingController toCityController = TextEditingController(text: '');

  TextEditingController shipmentNameController =
      TextEditingController(text: '');
  TextEditingController shipmentDateController =
      TextEditingController(text: '');
  TextEditingController shipmentNoteController =
      TextEditingController(text: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _statesController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  void _hideOverlay() {
    print('sasas');
    _overlayEntry?.remove();
    _overlayEntry = null;
    _statesOverlayEntry?.remove();
    _statesOverlayEntry = null;
    setState(() {
      _isFromCityClicked = false;
      _isToCityClicked = false;
      _isFromCountryClicked = false;
      _isToCountryClicked = false;
    });
  }

  void _showOverlay(BuildContext context, String type, GlobalKey key) {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
    _overlayEntry = _createOverlayEntry(context, type, key);
    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry(
      BuildContext context, String type, GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              top: offset.dy + size.height,
              left: offset.dx,
              width: size.width,
              child: SlideTransition(
                  position: _animation,
                  child: CountriesList(
                    countries: widget.countriesFlagsDto,
                    selectFromCountry:
                        _isFromCountryClicked ? selectFromCountry : null,
                    selectToCountry:
                        _isToCountryClicked ? selectDestinationCountry : null,
                    hideOverLay: _hideOverlay,
                  )),
            ));
  }

  void _showStatesOverlay(
      BuildContext context, String type, GlobalKey key, List<StateDto> states) {
    _statesController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _statesController,
      curve: Curves.easeInOut,
    ));
    _statesController.forward();
    _statesOverlayEntry = _createStatesOverlayEntry(context, type, key, states);
    Overlay.of(context).insert(_statesOverlayEntry!);
  }

  OverlayEntry _createStatesOverlayEntry(
      BuildContext context, String type, GlobalKey key, List<StateDto> states) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
        builder: (context) => Positioned(
              top: offset.dy + size.height,
              left: offset.dx,
              width: size.width,
              child: SlideTransition(
                  position: _animation,
                  child: StatesList(
                    stateDto: states,
                    selectFromState: _isFromCityClicked ? selectFromCity : null,
                    selectToState: _isToCityClicked ? selectToCity : null,
                    hideOverLay: _hideOverlay,
                  )),
            ));
  }

  void selectFromCountry(String selectedCountry) {
    _hideOverlay();
    var index = widget.countriesFlagsDto.countries
        ?.indexWhere((country) => country.name == selectedCountry);
    var countryStates = widget.countriesFlagsDto.countries![index!].states;
    fromCountryIso = widget.countriesFlagsDto.countries![index].iso2;

    setState(() {
      fromCountry = selectedCountry;
      fromCity = 'Select a city';
      fromCountryFlag = widget
          .countriesFlagsDto
          .countries![widget.countriesFlagsDto.countries!
              .indexWhere((country) => country.name == fromCountry)]
          .flag;
      fromStatesList = countryStates!;
      if (checkIsButtonEnabled()) {
        _isButtonEnabled = true;
        print('enabled');
      }
    });
    print('from $fromCountry');
  }

  void selectFromCity(String selectedCity) {
    _hideOverlay();

    setState(() {
      fromCity = selectedCity;
      // fromCityValue = '';
      if (checkIsButtonEnabled()) {
        _isButtonEnabled = true;
        print('enabled');
      }
    });
    print('from $fromCity');
  }

  void selectToCity(String selectedCity) {
    _hideOverlay();

    setState(() {
      toCity = selectedCity;
      // fromCityValue = '';
      if (checkIsButtonEnabled()) {
        _isButtonEnabled = true;
        print('enabled');
      }
    });
    print('to $toCity');
  }

  void selectDestinationCountry(String selectedCountry) {
    _hideOverlay();
    var index = widget.countriesFlagsDto.countries
        ?.indexWhere((country) => country.name == selectedCountry);
    var countryStates = widget.countriesFlagsDto.countries![index!].states;
    toCountryIso = widget.countriesFlagsDto.countries![index].iso2;

    setState(() {
      toCountryName = selectedCountry;
      toCity = 'Select a city';

      // fromCityValue = '';
      toCountryFlag = widget
          .countriesFlagsDto
          .countries![widget.countriesFlagsDto.countries!
              .indexWhere((country) => country.name == toCountryName)]
          .flag;
      toStatesList = countryStates!;
      if (checkIsButtonEnabled()) {
        _isButtonEnabled = true;
        print('enabled');
      }
    });
    print('to $toCountryName');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => _hideOverlay(),
      child: SingleChildScrollView(
        physics: _isFromCountryClicked ||
                _isFromCityClicked ||
                _isToCountryClicked ||
                _isToCityClicked
            ? NeverScrollableScrollPhysics()
            : null,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFFD6D6D6)),
                ),
                child: Column(
                  children: [
                    _isFromCountryClicked
                        ? Expanded(
                            flex: 1,
                            child: Material(
                              key: shipmentFromKey,
                              elevation: 10.0, // Elevation value
                              color: Colors.white,

                              child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Image.asset(
                                                  'images/takeoff.png',
                                                  width: 17,
                                                  height: 17,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 110,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  // alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Shipment From',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            width: 130,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Select a country',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Color(0xFFADADAD),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        : fromCountry == null
                            ? Expanded(
                                flex: 1,
                                key: shipmentFromKey,
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: CustomFormFieldForSeaarch(
                                      controller: fromController,
                                      // key:
                                      //     shipmentFromKey,
                                      readOnly: true,
                                      hint: 'Shipment From',
                                      onTap: () {
                                        _isFromCountryClicked =
                                            !_isFromCountryClicked;
                                        print(_isFromCountryClicked);
                                        setState(() {
                                          if (_overlayEntry != null) {
                                            _overlayEntry?.remove();
                                            _overlayEntry = null;
                                            _isFromCityClicked = false;
                                          }
                                        });
                                        // _overlayEntry
                                        //     ?.remove();

                                        _showOverlay(context, 'shipment from',
                                            shipmentFromKey);

                                        // showFromCountriesListBottomSheet(
                                        //     context,
                                        //     args!
                                        //         .countriesFlagsDto);
                                      },
                                      prefixIcon: Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        child: Image.asset(
                                          'images/takeoff.png',
                                          width: 17,
                                          height: 17,
                                        ),
                                      ),
                                      suffixICon: Container(
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          // size: 20,
                                          color: Color(0xFFADADAD),
                                        ),
                                      ),
                                    )),
                              )
                            : Expanded(
                                flex: 1,
                                key: shipmentFromKey,
                                child: InkWell(
                                  onTap: () {
                                    _isFromCountryClicked =
                                        !_isFromCountryClicked;
                                    setState(() {
                                      if (_overlayEntry != null ||
                                          _statesOverlayEntry != null) {
                                        _overlayEntry?.remove();
                                        _overlayEntry = null;
                                        _statesOverlayEntry?.remove();
                                        _statesOverlayEntry = null;
                                        _isFromCityClicked = false;
                                      }
                                    });
                                    // _overlayEntry
                                    //     ?.remove();
                                    _showOverlay(context, 'shipment from',
                                        shipmentFromKey);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: Image.asset(
                                                    'images/takeoff.png',
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 118,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Shipment From',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.network(
                                                    fromCountryFlag!,
                                                    fit: BoxFit.cover,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          .04,
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 20,
                                                  child: Text(
                                                    fromCountry!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Color(0xFFADADAD),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                        // margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        height: 1,
                        color: Color(0xFFD6D6D6),
                      ),
                    ),
                    _isFromCityClicked
                        ? Expanded(
                            flex: 1,
                            child: Material(
                              key: receivingInKey,
                              elevation: 10.0, // Elevation value
                              color: Colors.white,

                              child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Image.asset(
                                                  'images/land.png',
                                                  width: 17,
                                                  height: 17,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'From City',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            width: 130,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Select a city',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Color(0xFFADADAD),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        : fromCity == null
                            ? Expanded(
                                flex: 1,
                                key: receivingInKey,
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: CustomFormFieldForSeaarch(
                                      controller: fromCityController,
                                      // key:
                                      //     shipmentFromKey,
                                      readOnly: true,
                                      hint: 'from city',
                                      onTap: _isFromCountryClicked
                                          ? () {
                                              _isFromCityClicked =
                                                  !_isFromCityClicked;
                                              setState(() {
                                                if (_statesOverlayEntry !=
                                                        null ||
                                                    _overlayEntry != null) {
                                                  _overlayEntry?.remove();
                                                  _overlayEntry = null;
                                                  _statesOverlayEntry?.remove();
                                                  _statesOverlayEntry = null;
                                                  _isFromCountryClicked = false;
                                                }
                                              });
                                              // _overlayEntry
                                              //     ?.remove();
                                              _showStatesOverlay(
                                                  context,
                                                  'from city',
                                                  receivingInKey,
                                                  fromStatesList);

                                              // showFromCountriesListBottomSheet(
                                              //     context,
                                              //     args!
                                              //         .countriesFlagsDto);
                                            }
                                          : null,
                                      prefixIcon: Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        child: Image.asset(
                                          'images/land.png',
                                          width: 17,
                                          height: 17,
                                        ),
                                      ),
                                      suffixICon: Container(
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          // size: 20,
                                          color: Color(0xFFADADAD),
                                        ),
                                      ),
                                    )),
                              )
                            : Expanded(
                                flex: 1,
                                key: receivingInKey,
                                child: InkWell(
                                  onTap: () {
                                    _isFromCityClicked = !_isFromCityClicked;
                                    setState(() {
                                      if (_statesOverlayEntry != null ||
                                          _overlayEntry != null) {
                                        _overlayEntry?.remove();
                                        _overlayEntry = null;
                                        _statesOverlayEntry?.remove();
                                        _statesOverlayEntry = null;
                                      }
                                    });
                                    // _overlayEntry
                                    //     ?.remove();
                                    _showStatesOverlay(context, 'from city',
                                        receivingInKey, fromStatesList);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  // margin: EdgeInsets.only(right: 5),
                                                  child: Image.asset(
                                                    'images/takeoff.png',
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 105,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    // alignment:
                                                    //     Alignment.centerLeft,
                                                    child: Text(
                                                      'From City',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.network(
                                                    fromCountryFlag!,
                                                    fit: BoxFit.cover,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          .04,
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 20,
                                                  child: Text(
                                                    fromCity!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Color(0xFFADADAD),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
              Container(
                height: 170,
                margin: EdgeInsets.only(top: 17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Color(0xFFD6D6D6)),
                ),
                child: Column(
                  children: [
                    _isToCountryClicked
                        ? Expanded(
                            flex: 1,
                            child: Material(
                              key: shipmentToCountryKey,
                              elevation: 10.0, // Elevation value
                              color: Colors.white,

                              child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Image.asset(
                                                  'images/land.png',
                                                  width: 17,
                                                  height: 17,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 110,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Shipment To',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            width: 130,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                'Select a country',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Color(0xFFADADAD),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        : toCountryName == null
                            ? Expanded(
                                flex: 1,
                                key: shipmentToCountryKey,
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: CustomFormFieldForSeaarch(
                                      controller: toCountryController,
                                      // key:
                                      //     shipmentFromKey,
                                      readOnly: true,
                                      hint: 'Shipment To',
                                      onTap: () {
                                        _isToCountryClicked =
                                            !_isToCountryClicked;
                                        print(_isToCountryClicked);
                                        setState(() {
                                          if (_overlayEntry != null) {
                                            _overlayEntry?.remove();
                                            _overlayEntry = null;
                                            _isToCityClicked = false;
                                          }
                                        });
                                        // _overlayEntry
                                        //     ?.remove();

                                        _showOverlay(context, 'shipment to',
                                            shipmentToCountryKey);

                                        // showFromCountriesListBottomSheet(
                                        //     context,
                                        //     args!
                                        //         .countriesFlagsDto);
                                      },
                                      prefixIcon: Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        child: Image.asset(
                                          'images/land.png',
                                          width: 17,
                                          height: 17,
                                        ),
                                      ),
                                      suffixICon: Container(
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          // size: 20,
                                          color: Color(0xFFADADAD),
                                        ),
                                      ),
                                    )),
                              )
                            : Expanded(
                                flex: 1,
                                key: shipmentToCountryKey,
                                child: InkWell(
                                  onTap: () {
                                    _isToCountryClicked = !_isToCountryClicked;
                                    setState(() {
                                      if (_overlayEntry != null ||
                                          _statesOverlayEntry != null) {
                                        _overlayEntry?.remove();
                                        _overlayEntry = null;
                                        _statesOverlayEntry?.remove();
                                        _statesOverlayEntry = null;
                                        _isToCityClicked = false;
                                      }
                                    });
                                    // _overlayEntry
                                    //     ?.remove();
                                    _showOverlay(context, 'shipment to',
                                        shipmentToCountryKey);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  child: Image.asset(
                                                    'images/land.png',
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 118,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Shipment To',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.network(
                                                    toCountryFlag!,
                                                    fit: BoxFit.cover,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          .04,
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 20,
                                                  child: Text(
                                                    toCountryName!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Color(0xFFADADAD),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                        // margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        height: 1,
                        color: Color(0xFFD6D6D6),
                      ),
                    ),
                    _isToCityClicked
                        ? Expanded(
                            flex: 1,
                            child: Material(
                              key: shipmentToCityKey,
                              elevation: 10.0, // Elevation value
                              color: Colors.white,

                              child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                child: Image.asset(
                                                  'images/land.png',
                                                  width: 17,
                                                  height: 17,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100,
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'To City',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            width: 130,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Select a city',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right_rounded,
                                        color: Color(0xFFADADAD),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        : toCity == null
                            ? Expanded(
                                flex: 1,
                                key: shipmentToCityKey,
                                child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: CustomFormFieldForSeaarch(
                                      controller: toCityController,
                                      // key:
                                      //     shipmentFromKey,
                                      readOnly: true,
                                      hint: 'to city',
                                      onTap: _isToCountryClicked
                                          ? () {
                                              _isToCityClicked =
                                                  !_isToCityClicked;
                                              setState(() {
                                                if (_statesOverlayEntry !=
                                                    null) {
                                                  _statesOverlayEntry?.remove();
                                                  _statesOverlayEntry = null;
                                                  _isToCountryClicked = false;
                                                }
                                              });
                                              // _overlayEntry
                                              //     ?.remove();
                                              _showStatesOverlay(
                                                  context,
                                                  'to city',
                                                  shipmentToCityKey,
                                                  toStatesList);

                                              // showFromCountriesListBottomSheet(
                                              //     context,
                                              //     args!
                                              //         .countriesFlagsDto);
                                            }
                                          : null,

                                      prefixIcon: Container(
                                        margin:
                                            const EdgeInsets.only(right: 15),
                                        child: Image.asset(
                                          'images/land.png',
                                          width: 17,
                                          height: 17,
                                        ),
                                      ),
                                      suffixICon: Container(
                                        child: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          // size: 20,
                                          color: Color(0xFFADADAD),
                                        ),
                                      ),
                                    )),
                              )
                            : Expanded(
                                flex: 1,
                                key: shipmentToCityKey,
                                child: InkWell(
                                  onTap: () {
                                    _isToCityClicked = !_isToCityClicked;
                                    setState(() {
                                      if (_statesOverlayEntry != null) {
                                        _statesOverlayEntry?.remove();
                                      }
                                    });
                                    // _overlayEntry
                                    //     ?.remove();
                                    _showStatesOverlay(context, 'to city',
                                        shipmentToCityKey, toStatesList);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  // margin: EdgeInsets.only(right: 5),
                                                  child: Image.asset(
                                                    'images/land.png',
                                                    width: 17,
                                                    height: 17,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 70,
                                                  child: FittedBox(
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      'To City',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium,
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.network(
                                                    toCountryFlag!,
                                                    fit: BoxFit.cover,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          .04,
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 20,
                                                  child: Text(
                                                    toCity!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Color(0xFFADADAD),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                // padding: EdgeInsets.only(left: 20, right: 20),
                child: CustomFormField(
                  controller: shipmentNameController,
                  label: null,
                  hint: 'Shipment Name',
                  onChange: (p0) => checkIsButtonEnabled(),

                  keyboardType: TextInputType.name,
                  // validator: (text) {
                  //   if (text == null || text.trim().isEmpty) {
                  //     return 'please enter shipment name';
                  //   }
                  //   // if (!ValidationUtils.isValidEmail(text)) {
                  //   //   return 'please enter a valid email';
                  //   // }
                  // },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                // padding: EdgeInsets.only(left: 20, right: 20),
                child: CustomFormField(
                  controller: shipmentDateController,
                  readOnly: true,
                  // enabled: true,
                  onTap: () => _selectDate(context),
                  label: null,
                  hint: 'Before Date',
                  keyboardType: TextInputType.name,
                  // validator: (text) {
                  //   if (text == null || text.trim().isEmpty) {
                  //     return 'please enter email';
                  //   }
                  //   if (!ValidationUtils.isValidEmail(text)) {
                  //     return 'please enter a valid email';
                  //   }
                  // },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                // padding: EdgeInsets.only(left: 20, right: 20),
                child: CustomFormField(
                  controller: shipmentNoteController,
                  label: null,
                  hint: 'Notes',
                  onChange: (p0) => checkIsButtonEnabled(),

                  lines: 5,
                  keyboardType: TextInputType.name,
                  // validator: (text) {
                  //   if (text == null || text.trim().isEmpty) {
                  //     return 'please enter email';
                  //   }
                  //   if (!ValidationUtils.isValidEmail(text)) {
                  //     return 'please enter a valid email';
                  //   }
                  // },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: ButtonWidget(
                  isButtonEnabled: _isButtonEnabled,
                  onPressed: () {
                    widget.next(shipmentNameController.text);
                  },
                  buttonText: 'Add Items',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    if (Platform.isIOS) {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedDate = newDate;
                  final formattedDate = DateFormat('dd MMMM yyyy')
                      .format(selectedDate); // Format the dateController

                  shipmentDateController.text = formattedDate;
                  date = selectedDate.toIso8601String();
                  print(date);
                  checkIsButtonEnabled();
                  // dateController = selectedDate.toIso8601String();

                  //                   final formattedDate = TimeOfDay.fromDateTime(selectedDate);
                  // // Format the dateController
                  // dateController.text = formattedDate.format(context);
                });
              },
            ),
          );
        },
      );
    } else if (Platform.isAndroid) {
      var picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          final formattedDate = DateFormat('dd MMMM yyyy')
              .format(selectedDate); // Format the dateController
          // Format the dateController
          shipmentDateController.text = formattedDate;
          date = selectedDate.toIso8601String();
          checkIsButtonEnabled();

          // dateController = selectedDate.toIso8601String();
        });
      }
    }
  }

  bool checkIsButtonEnabled() {
    print('checl');
    if (fromCountry != null &&
        toCountryName != null &&
        fromCity != null &&
        toCity != null &&
        shipmentDateController.text.trim().isNotEmpty &&
        shipmentNameController.text.trim().isNotEmpty) {
      setState(() {
        _isButtonEnabled = true;
      });
      print('trueeeeeeee');
      return _isButtonEnabled;
    } else {
      print('falseee');
      setState(() {
        _isButtonEnabled = false;
      });
      return _isButtonEnabled;
    }
  }
}
