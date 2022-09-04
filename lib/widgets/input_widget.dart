import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String? hintText;
  final IconData? suffixIcon;
  final bool obscureText;
  final void Function(String?)? onSaved;
  final void Function(String?)? onchaged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final double? radiusAmount;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;

  const InputWidget({
    Key? key,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.onSaved,
    this.onchaged,
    this.validator,
    this.controller,
    this.radiusAmount = 5,
    this.height = 43,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.center,
        initialValue: initialValue,
        keyboardType: keyboardType,
        minLines: minLines,
        maxLines: maxLines,
        onSaved: onSaved,
        onChanged: onchaged,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscureText,
        controller: controller,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: height! / 10, horizontal: 10.0),
          fillColor: Colors.grey[200],
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[500],
          ),
          prefixIcon: suffixIcon == null
              ? null
              : Icon(
                  suffixIcon,
                  color: Colors.black,
                ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]!, width: 0.0),
            borderRadius: BorderRadius.circular(radiusAmount!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]!, width: 0.0),
            borderRadius: BorderRadius.circular(radiusAmount!),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]!, width: 0.0),
            borderRadius: BorderRadius.circular(radiusAmount!),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]!, width: 0.0),
            borderRadius: BorderRadius.circular(radiusAmount!),
          ),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
