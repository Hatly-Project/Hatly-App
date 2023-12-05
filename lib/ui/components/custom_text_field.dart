import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);
typedef OnTap = void Function()?;
typedef OnChange = void Function(String)?;

class CustomFormField extends StatelessWidget {
  String label;
  String hint;
  bool isPassword;
  bool readOnly;
  TextInputType keyboardType;
  Widget? icon;
  MyValidator validator;
  TextEditingController controller;
  int lines;
  bool? enabled;
  OnTap? onTap;
  OnChange? onChange;

  CustomFormField(
      {required this.label,
      required this.validator,
      required this.controller,
      required this.hint,
      this.enabled = true,
      this.readOnly = false,
      this.icon,
      this.onTap,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.onChange,
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
            readOnly: readOnly,
            enabled: enabled,
            onTap: onTap,
            onChanged: onChange,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              fillColor: Colors.grey[300],
              filled: true,
              icon: icon,
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
