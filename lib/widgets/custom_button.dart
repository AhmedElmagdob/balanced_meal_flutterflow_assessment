import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/screen_utils.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.padding,
    this.margin,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);
    final buttonPadding = padding ?? EdgeInsets.symmetric(
      vertical: ScreenUtils.getProportionateScreenHeight(12),
      horizontal: ScreenUtils.getProportionateScreenWidth(24),
    );

    return Container(
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: onPressed != null
            ? (backgroundColor ?? const Color(0xFFF25700))
            : Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Padding(
            padding: buttonPadding,
            child: Center(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: textColor ?? (onPressed != null ? Colors.white : Colors.black54),
                  fontSize: ScreenUtils.getProportionateScreenWidth(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 