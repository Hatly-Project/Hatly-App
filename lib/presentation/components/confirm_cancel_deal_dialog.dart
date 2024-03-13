import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmCancelDealDialog extends StatelessWidget {
  Function confirmCancellation;
  ConfirmCancelDealDialog({required this.confirmCancellation});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Are you sure to cancel this deal?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 60),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        side: const BorderSide(color: Colors.white, width: 2),
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      confirmCancellation();
                    },
                    child: const Text(
                      'Canel',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(140, 60),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        side: const BorderSide(color: Colors.white, width: 2),
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      confirmCancellation();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
