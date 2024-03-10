import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  const CustomDropdownFormField({
    Key? key,
    required this.items,
    this.onChanged,
  }) : super(key: key);

  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 80,
      child: DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an option';
          }
          return null; // Return null if the value is valid
        },
        items: items,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff1D242E))),
          hintText: 'Select an option',
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
