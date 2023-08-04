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
        ? Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: ImageIcon(
              AssetImage('images/$imageName.png'),
              color: Theme.of(context).primaryColor,
            ),
          )
        : ImageIcon(
            AssetImage('images/$imageName.png'),
            color: Colors.white,
            size: 25,
          );
  }
}
