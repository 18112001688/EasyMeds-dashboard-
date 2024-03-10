import 'package:flutter/material.dart';
import 'package:medcs_dashboard/core/utlity/styles.dart';

class CustomInfoWidget extends StatelessWidget {
  const CustomInfoWidget(
      {super.key,
      required this.title,
      required this.numberTitleOne,
      required this.firstTitle,
      required this.numberTitleTwo,
      required this.secondryTitleTwo,
      required this.paddingtoRight,
      required this.space});
  final String title;
  final String numberTitleOne;
  final String firstTitle;
  final String numberTitleTwo;
  final String secondryTitleTwo;
  final double paddingtoRight;
  final double space;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500, // Fixed width
      height: 180, // Fixed height
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black)),
      child: Stack(
        children: [
          Positioned(
            left: 50.5, // Fixed position
            top: 10, // Fixed position
            child: Text(
              title,
              style: StylesLight.bodyLarge17,
            ),
          ),
          Positioned(
            top: 50, // Fixed position
            child: Container(
              width: 500, // Fixed width
              height: 1,
              color: Colors.black,
            ),
          ),
          Positioned(
            top: 80, // Fixed position
            right: paddingtoRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      numberTitleOne,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      firstTitle,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  width: space,
                ),
                Column(
                  children: [
                    Text(
                      numberTitleTwo,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      secondryTitleTwo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
