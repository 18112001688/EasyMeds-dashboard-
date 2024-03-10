import 'package:flutter/material.dart';

class CustomTitleFormField extends StatelessWidget {
  const CustomTitleFormField({Key? key, required this.controller})
      : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 80,
      child: TextFormField(
        maxLength: 80,
        maxLines: 2,
        minLines: 2,
        keyboardType: TextInputType.text,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a valid Medicine name";
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          hintText: 'Add Medicine Name',
          hintStyle: TextStyle(
            color: Color(0xffA1A8B0),
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
