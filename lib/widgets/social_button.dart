import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    Key? key,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
    required this.onTap,
    required this.iconName,
    this.borderRadius = 5,
    this.isBlur = false,
  }) : super(key: key);

  final String text;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  final bool isBlur;
  final double borderRadius;
  final String iconName;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: GestureDetector(
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: isBlur ? 10.0 : 0, sigmaY: isBlur ? 10.0 : 0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/$iconName.svg',
                  height: 24,
                ),
                SizedBox(width: 16),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
