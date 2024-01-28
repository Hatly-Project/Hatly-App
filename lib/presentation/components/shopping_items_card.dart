import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hatly/domain/models/item_dto.dart';
import 'package:hatly/domain/models/photo_dto.dart';
import 'package:hatly/presentation/home/tabs/home/home_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoppingItemsCard extends StatefulWidget {
  ItemDto itemDto;
  ShoppingItemsCard({required this.itemDto});

  @override
  State<ShoppingItemsCard> createState() => _ShoppingItemsCardState();
}

class _ShoppingItemsCardState extends State<ShoppingItemsCard> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    ItemDto itemDto = widget.itemDto;
    List<PhotoDto> itemImages = widget.itemDto.photos!;
    List<Image>? convertedImages = itemImages
        .map((image) => Image.network(
              image.photo!,
              fit: BoxFit.cover,
            ))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          _launchURL(itemDto.link!);
        },
        child: Card(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlideshow(
                  width: double.infinity,
                  height: 100,
                  indicatorRadius: 4,
                  indicatorPadding: 6,
                  initialPage: 0,
                  indicatorColor: Theme.of(context).primaryColor,
                  children: convertedImages
                      .map((image) => ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          child: image))
                      .toList()),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            itemDto.name!,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                        ),
                        Text(
                          'Quantity:1',
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '\$USD ${itemDto.price}',
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'images/weight.png',
                              width: 45,
                              height: 20,
                            ),
                            Text(
                              '${itemDto.weight} g',
                              overflow: TextOverflow.clip,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    var link = Uri.parse(url);
    if (await canLaunchUrl(link)) {
      await launchUrl(link);
    } else {
      throw 'Could not launch $url';
    }
  }

  Image base64ToImage(String base64String) {
    Uint8List bytes = base64.decode(base64String);
    return Image.memory(
      bytes,
      fit: BoxFit.cover,
    );
  }
}
