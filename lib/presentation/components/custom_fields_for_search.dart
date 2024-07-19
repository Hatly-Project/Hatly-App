import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);
typedef OnTap = void Function()?;
typedef OnChange = void Function(String)?;

class CustomFormFieldForSeaarch extends StatelessWidget {
  String? label;
  String hint;
  bool isPassword;
  bool readOnly;
  TextInputType keyboardType;
  Widget? icon;
  Widget? suffixICon, prefixIcon, labelWidget;
  Key? key;
  MyValidator? validator;
  String? initialValue;
  TextEditingController controller;
  int lines;
  int? maxLength;
  bool? enabled;
  OnTap? onTap;
  OnChange? onChange;

  CustomFormFieldForSeaarch(
      {this.label,
      this.validator,
      required this.controller,
      required this.hint,
      this.maxLength,
      this.prefixIcon,
      this.key,
      this.suffixICon,
      this.enabled = true,
      this.readOnly = false,
      this.icon,
      this.labelWidget,
      this.initialValue,
      this.onTap,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.onChange,
      this.lines = 1})
      : super(key: key);

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
            // key: key,
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
              // suffix: suffixICon,
              label: labelWidget,
              // prefixIcon: prefixIcon,
              suffixIcon: suffixICon,
              suffixIconConstraints: BoxConstraints.loose(const Size(50, 50)),
              prefixIcon: prefixIcon,
              prefixIconConstraints: BoxConstraints.loose(const Size(50, 50)),
              hintText: hint,
              hintStyle: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.w300, fontSize: 17),
              focusedBorder: readOnly
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFD6D6D6), width: 1),
                    ),
              border: readOnly
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFD6D6D6), width: 1),
                    ),
              enabledBorder: readOnly
                  ? InputBorder.none
                  : OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          BorderSide(color: Color(0xFFD6D6D6), width: 1),
                    ),
              disabledBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
