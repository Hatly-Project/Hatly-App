import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  bool isButtonEnabled;
  Function onPressed;
  String buttonText;
  ButtonWidget(
      {required this.isButtonEnabled,
      required this.onPressed,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 60),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          backgroundColor: isButtonEnabled
              ? Theme.of(context).primaryColor
              : const Color(0xFFEEEEEE),
          padding: const EdgeInsets.symmetric(vertical: 12)),
      onPressed: isButtonEnabled
          ? () {
              onPressed();
            }
          : null,
      child: Text(
        buttonText,
        style: isButtonEnabled
            ? Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontSize: 16,
                fontWeight: FontWeight.w600)
            : Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
