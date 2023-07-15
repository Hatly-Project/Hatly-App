import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  String label;
  String hint;
  bool isPassword;
  TextInputType keyboardType;

  MyValidator validator;
  TextEditingController controller;
  int lines;

  CustomFormField(
      {required this.label,
      required this.validator,
      required this.controller,
      required this.hint,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.lines = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            maxLines: lines,
            minLines: lines,
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: isPassword,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white, width: 1)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
