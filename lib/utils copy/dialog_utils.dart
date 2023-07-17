import 'package:flutter/material.dart';

class DialogUtils {
  static void getDialog(
      String? alertMsg, String? alertContent, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(alertMsg!),
            content: Text(alertContent!),
            actions: [TextButton(onPressed: () {}, child: Text('Ok'))],
          );
        });
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
