import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final Color dividerColor;
  final Color textColor;
  final double dividerThickness;
  final EdgeInsetsGeometry padding;
  
  const DividerWithText({
    Key? key,
    required this.text,
    this.dividerColor = const Color(0xFFDDDDDD),
    this.textColor = const Color(0xFF757575),
    this.dividerThickness = 1.0,
    this.padding = const EdgeInsets.symmetric(vertical: 24.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: dividerColor,
              thickness: dividerThickness,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: dividerColor,
              thickness: dividerThickness,
            ),
          ),
        ],
      ),
    );
  }
} 