import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class BottomNavIcon extends StatelessWidget {
  String imageName;
  bool isSelected;
  BottomNavIcon(this.imageName, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: ImageIcon(
              AssetImage('images/$imageName.png'),
              // size: 25,
              // color: Theme.of(context).primaryColor,
            ),
          )
        : imageName == 'Add'.toLowerCase()
            ? Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.add_rounded,
                      size: 33,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    'Add',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 15, color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: ImageIcon(
                  AssetImage('images/$imageName.png'),
                  // size: 25,
                  // color: Theme.of(context).primaryColor,
                ),
              );
  }
}

        // ? Container(
        //     padding: EdgeInsets.all(6),
        //     decoration: BoxDecoration(
        //         color: Colors.white, borderRadius: BorderRadius.circular(20)),

