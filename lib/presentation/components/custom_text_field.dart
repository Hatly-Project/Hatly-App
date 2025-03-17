import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);
typedef OnTap = void Function()?;
typedef OnChange = void Function(String)?;

class CustomFormField extends StatelessWidget {
  String? label;
  String hint;
  bool isPassword;
  bool readOnly;
  TextInputType keyboardType;
  Widget? icon;
  Widget? suffixICon;

  MyValidator? validator;
  String? initialValue;
  TextEditingController controller;
  int lines;
  int? maxLength;
  bool? enabled;
  OnTap? onTap;
  OnChange? onChange;

  CustomFormField(
      {this.label,
      this.validator,
      required this.controller,
      required this.hint,
      this.maxLength,
      this.suffixICon,
      this.enabled = true,
      this.readOnly = false,
      this.icon,
      this.initialValue,
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
          label != null
              ? Text(
                  label ?? '',
                  style: TextStyle(color: Colors.white),
                )
              : Container(),
          TextFormField(
            maxLines: lines,
            initialValue: initialValue,
            minLines: lines,
            controller: controller,
            maxLength: maxLength,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: isPassword,
            readOnly: readOnly,
            enabled: enabled,
            onTap: onTap,
            onChanged: onChange,
            cursorColor: Theme.of(context).primaryColor,
            decoration: InputDecoration(
              fillColor: Colors.transparent,
              filled: true,
              icon: icon,
              suffixIcon: suffixICon,
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.w300),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Color(0xFFD6D6D6), width: 1)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Color(0xFFD6D6D6), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Color(0xFFD6D6D6), width: 1),
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: Color(0xFFD6D6D6), width: 1)),
            ),
          ),
        ],
      ),
    );
  }
}
