import 'package:flutter/material.dart';
import 'package:jcdriver/utilities/constants/colors.dart';

class SigninTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  const SigninTextfield(
      {super.key, required this.labelText, required this.controller,required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      
      obscureText: obscureText,
      decoration: InputDecoration(
        
        floatingLabelStyle: TextStyle(color: IKColors.primary),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          color: IKColors.primary,
        )),
        labelText: labelText,
        contentPadding: const EdgeInsets.all(15),
        filled: true,
        border: const OutlineInputBorder(),
        fillColor: IKColors.light,
        
      ),
    );
  }
}
