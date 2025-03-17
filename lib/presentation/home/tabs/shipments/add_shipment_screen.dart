import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hatly/presentation/home/tabs/home/home_screen_arguments.dart';
import 'package:hatly/presentation/home/tabs/shipments/add_shipment_details_tab.dart';
import 'package:hatly/presentation/home/tabs/shipments/add_shipment_items_tab.dart';
import 'package:hatly/providers/countries_list_provider.dart';

class AddShipmentScreen extends StatefulWidget {
  static const routeName = 'AddShipment';
  AddShipmentScreen({super.key});

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _nextTab(String? shipmentName) {
    print('Nameee $shipmentName');
    if (_tabController.index < 2) {
      setState(() {
        _tabController.animateTo(_tabController.index + 1);
      });
    }
  }

  void _previousTab() {
    if (_tabController.index > 0) {
      setState(() {
        _tabController.animateTo(_tabController.index - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: true,
        leading: IconButton(
          onPressed: () {
            if (_tabController.index > 0) {
              setState(() {
                _tabController.animateTo(_tabController.index - 1);
              });
            } else {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Add Shipment',
          style:
              Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey[200]!,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _tabController.index == 0
                              ? Image.asset(
                                  'images/first_step.png',
                                  width: 50,
                                  height: 50,
                                )
                              : Image.asset(
                                  'images/completed_step.png',
                                  width: 50,
                                  height: 50,
                                ),
                          Text(
                            'Add details',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontSize: 13),
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _tabController.index == 0
                        ? Expanded(
                            child: Image.asset(
                              'images/steps_disabled.png',
                              width: 70,
                            ),
                          )
                        : Expanded(
                            child: Image.asset(
                              'images/steps_enabled.png',
                              width: 70,
                            ),
                          ),
                    Expanded(
                      child: Column(
                        children: [
                          _tabController.index == 1
                              ? Image.asset(
                                  'images/second_step_enabled.png',
                                  width: 50,
                                  height: 50,
                                )
                              : Image.asset(
                                  'images/second_step_disabled.png',
                                  width: 50,
                                  height: 50,
                                ),
                          Text(
                            'Add items',
                            style: _tabController.index == 1
                                ? Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(fontSize: 13)
                                : Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(fontSize: 13),
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _tabController.index == 2
                        ? Expanded(
                            child: Image.asset(
                              'images/steps_enabled.png',
                              width: 70,
                            ),
                          )
                        : Expanded(
                            child: Image.asset(
                              'images/steps_disabled.png',
                              width: 70,
                            ),
                          ),
                    Expanded(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _tabController.index == 2
                              ? Image.asset(
                                  'images/third_step_enabled.png',
                                  width: 50,
                                  height: 50,
                                )
                              : Image.asset(
                                  'images/third_step_disabled.png',
                                  width: 50,
                                  height: 50,
                                ),
                          Text(
                            'Review',
                            style: _tabController.index == 2
                                ? Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(fontSize: 13)
                                : Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(fontSize: 13),
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  AddShipmentDetailsTab(
                    countriesFlagsDto:
                        context.read<CountriesListProvider>().countries!,
                    next: _nextTab,
                  ),
                  AddShipmentItemsTab()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String text) {
    return Center(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Text(
          text,
          key: ValueKey<String>(text),
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
