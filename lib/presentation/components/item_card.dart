import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hatly/domain/models/shipment_dto.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemCard extends StatefulWidget {
  ShipmentDto shipmentDto;
  int index;
  final ValueChanged<double> onHeightCalculated;
  ItemCard(
      {required this.shipmentDto,
      required this.index,
      required this.onHeightCalculated});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateHeight();
    });
  }

  void _calculateHeight() {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final height = renderBox.size.height;
    print('heighttttt $height');
    widget.onHeightCalculated(height);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 15),
      key: _key,
      // height: 200,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 11),
                child: Image.network(
                  widget.shipmentDto.items![widget.index].photos!.first.photo!,
                  fit: BoxFit.fitHeight,
                  width: 70,
                  height: 70,
                ),
              ),
              Container(
                height: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .6,
                      height: 21,
                      child: Text(
                        widget.shipmentDto.title!,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .6,
                      // height: 21,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/weight_icob.png',
                                  width: 14,
                                  height: 14,
                                  color: Color(0xFF5A5A5A),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(left: 2),
                                  width: 65,
                                  child: Text(
                                    'Weight: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFF5A5A5A)),
                                    textAlign: TextAlign.center,
                                    textScaler: TextScaler.noScaling,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(left: 2),
                                  // width: 100,
                                  child: Text(
                                    '${widget.shipmentDto.items![widget.index].weight}g',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                        ),
                                    textAlign: TextAlign.center,
                                    textScaler: TextScaler.noScaling,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'images/weight_icob.png',
                                width: 14,
                                height: 14,
                                color: Color(0xFF5A5A5A),
                              ),
                              Container(
                                // margin: EdgeInsets.only(left: 2),
                                // width: 200,
                                child: Text(
                                  ' Quantity: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w300,
                                          color: Color(0xFF5A5A5A)),
                                  textAlign: TextAlign.center,
                                  textScaler: TextScaler.noScaling,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${widget.shipmentDto.items![widget.index].quantity}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                textAlign: TextAlign.center,
                                textScaler: TextScaler.noScaling,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/price_icon.png',
                          width: 20,
                          height: 20,
                          color: Color(0xFF5A5A5A),
                          // fit: BoxFit.fitWidth,
                        ),
                        Text(
                          'Price: ',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFF5A5A5A)),
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.noScaling,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          // margin: EdgeInsets.only(left: 2),
                          // width: 200,
                          child: Text(
                            ' ${widget.shipmentDto.items![widget.index].price} USD',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.noScaling,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () =>
                _launchUrl(url: widget.shipmentDto.items![widget.index].link),
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 17),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEEEEEE)),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 280,
                      height: 22,
                      child: Text(
                        '${widget.shipmentDto.items![widget.index].link}',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 18,
                                  color: Color(0xFF6A80E8),
                                ),
                        textScaler: TextScaler.noScaling,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: Color(0xFF6A80E8),
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl({String? url}) async {
    final Uri uri = Uri.parse(url!);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
