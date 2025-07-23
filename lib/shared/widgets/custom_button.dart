import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 150,
    this.height = 50,
    this.color,
    this.textColor,
    this.borderRadius = 8.0,
    this.isBordered = false,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final bool isBordered;
  final bool isLoading;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isBordered
              ? Theme.of(context).colorScheme.surface
              : color ?? Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: isBordered
                ? BorderSide(
                    color: color ?? Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            if (icon != null) icon!,
            isLoading
                ? CupertinoActivityIndicator(
                    color: isBordered
                        ? Theme.of(context).colorScheme.primary
                        : textColor ?? Theme.of(context).colorScheme.onPrimary,
                  )
                : Text(
                    text,
                    style: TextStyle(
                      color: isBordered
                          ? Theme.of(context).colorScheme.primary
                          : textColor ??
                                Theme.of(context).colorScheme.onPrimary,
                      fontSize: 15,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
