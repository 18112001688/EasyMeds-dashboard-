import 'package:flutter/material.dart';

class CustomDescriptionField extends StatelessWidget {
  const CustomDescriptionField({Key? key, required this.controller})
      : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: TextFormField(
        minLines: 2,
        maxLength: 1000,

        keyboardType: TextInputType.multiline,
        maxLines:
            8, // This allows the TextFormField to expand as the user enters more lines.
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a valid Description";
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          hintText: 'Add Description ',
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
