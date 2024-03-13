import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CounterOfferDialog extends StatelessWidget {
  Function sendReward;
  CounterOfferDialog({required this.sendReward});
  var formKey = GlobalKey<FormState>();
  TextEditingController rewardController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: MediaQuery.sizeOf(context).width,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Enter your counter reward',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: rewardController,
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your reward value';
                  }
                  return '';
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(17)),
                  ),
                  labelText: 'Enter the reward',
                ),
                keyboardType: TextInputType.number,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      side: const BorderSide(color: Colors.white, width: 2),
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12)),
                  onPressed: () {
                    if (formKey.currentState?.validate() == false) {
                      return;
                    }
                    sendReward(rewardController.text);
                  },
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
