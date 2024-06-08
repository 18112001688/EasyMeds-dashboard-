import 'package:flutter/material.dart';

class CustomPassFormField extends StatefulWidget {
  const CustomPassFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<CustomPassFormField> createState() => _CustomPassFormFieldState();
}

class _CustomPassFormFieldState extends State<CustomPassFormField> {
  bool _obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 410,
      padding: const EdgeInsets.only(
        left: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF1F3F6),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please Enter a valid Pass";
          }

          return null;
        },
        decoration: InputDecoration(
            border:const OutlineInputBorder(borderSide: BorderSide.none),
            hintText: 'Enter your Password ',
            hintStyle : const TextStyle(
              color: Color(0xffA1A8B0),
              fontFamily: 'inter',
              fontSize: 16,
              height: 1.5,
              letterSpacing: 2,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
            ),
            prefixIcon:const Icon(
              Icons.lock_outline,
              color: Color(0xffA1A8B0),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _obsecureText = !_obsecureText;
                });
              },
              icon: Icon(
                _obsecureText ? Icons.visibility_off : Icons.visibility,
              ),
            )),
        obscureText: _obsecureText,
      ),
    );
  }
}
