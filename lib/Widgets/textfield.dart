import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? initialValue;
  final void Function(String)? onChanged;
  final bool? obscureText;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? maxLine;

  const CustomTextField({
    Key? key,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.obscureText,
    this.keyboard,
    this.controller,
    this.validator,
    this.maxLength,
    this.maxLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextFormField(
        maxLines: maxLine ?? 1,
        maxLength: maxLength,
        initialValue: initialValue,
        onChanged: onChanged,
        controller: controller,
        validator: validator,
        keyboardType: keyboard ?? TextInputType.text,
        obscureText: obscureText ?? false,
        cursorColor: const Color.fromARGB(255, 0, 174, 239),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 106, 166),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 0, 106, 166),
            ),
          ),
        ),
      ),
    );
  }
}