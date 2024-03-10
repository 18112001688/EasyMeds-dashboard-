import 'package:flutter/material.dart';

class CustomIDField extends StatelessWidget {
  const CustomIDField({Key? key, required this.controller}) : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 80,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter an numeric ID";
          }
          if (!RegExp(r'^\d+$').hasMatch(value)) {
            return 'Please enter a valid number';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          hintText: 'Enter ID',
          hintStyle: TextStyle(
            color: Color(0xffA1A8B0),
            fontFamily: 'inter',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
