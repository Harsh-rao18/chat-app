import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final FocusNode? focusNode;

  const AuthInput({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isPassword = false,
    this.validator,
    this.suffixIcon,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
