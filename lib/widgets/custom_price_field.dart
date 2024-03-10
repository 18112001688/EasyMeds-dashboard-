import 'package:flutter/material.dart';

class CustomPriceField extends StatelessWidget {
  const CustomPriceField({Key? key, required this.controller})
      : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 80,
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter a valid price";
          }
          if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
            return 'Please enter a valid number';
          }
          return null;
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          hintText: 'Enter price',
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
