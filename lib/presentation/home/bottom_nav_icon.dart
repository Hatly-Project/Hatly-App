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
        ? imageName == 'Add'.toLowerCase()
            ? Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Icon(
                  Icons.add,
                  size: 33,
                ))
            : Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: ImageIcon(
                  AssetImage('images/$imageName.png'),
                  // size: 25,
                  // color: Theme.of(context).primaryColor,
                ),
              )
        : imageName == 'Add'.toLowerCase()
            ? Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(26)),
                child: Icon(
                  Icons.add,
                  size: 33,
                  color: Colors.white,
                ))
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

