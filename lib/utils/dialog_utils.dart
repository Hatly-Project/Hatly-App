import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showDialogAndroid(
      {String? alertMsg,
      String? alertContent,
      required BuildContext context,
      void Function()? onAction,
      int? statusCode}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(alertMsg!),
            content: Text(alertContent!),
            actions: [
              TextButton(
                onPressed: statusCode == 401
                    ? onAction
                    : () => Navigator.of(context).pop(),
                child:
                    statusCode == 401 ? const Text('Login') : const Text('Ok'),
              )
            ],
          );
        });
  }

  // This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
  static void showDialogIos(
      {required BuildContext context,
      String? alertMsg,
      String? alertContent,
      void Function()? onAction,
      int? statusCode}) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          alertMsg!,
          style: TextStyle(
              color: alertMsg == 'Fail'
                  ? Colors.red
                  : alertMsg == 'success'
                      ? Colors.green
                      : Colors.black),
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
            onPressed: statusCode == 401
                ? onAction
                : () => Navigator.of(context).pop(),
            child: statusCode == 401 ? const Text('Login') : const Text('Ok'),
          ),
        ],
      ),
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
