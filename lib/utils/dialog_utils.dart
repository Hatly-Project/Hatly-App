import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showDialogAndroid(
      {String? alertMsg, String? alertContent, required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text(alertMsg!),
            content: Text(alertContent!),
            actions: [
              TextButton(
                  onPressed: () {
                    hideDialog(context);
                  },
                  child: Text('Ok'))
            ],
          );
        });
  }

  // This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  static void showDialogIos(
      {required BuildContext context, String? alertMsg, String? alertContent}) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          alertMsg!,
          style:
              TextStyle(color: alertMsg == 'Fail' ? Colors.red : Colors.black),
        ),
        content: Text(
          alertContent!,
          textAlign: TextAlign.center,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
