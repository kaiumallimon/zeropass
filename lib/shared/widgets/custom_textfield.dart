import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.label,
    required this.hintText,
    required this.keyboardType,
    this.width,
    this.height,
    this.controller,
    this.obscureText = false,
  });

  final String? label;
  final String hintText;
  final TextInputType keyboardType;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height ?? 50,
          child: TextField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: _obscure,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.onSurface.withOpacity(0.2),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
              suffixIcon: widget.obscureText
                  ? GestureDetector(
                      child: HugeIcon(
                        icon: _obscure
                            ? HugeIcons.strokeRoundedViewOff
                            : HugeIcons.strokeRoundedView,
                        color: colorScheme.primary.withOpacity(0.6),
                      ),
                      onTap: () {
                        setState(() {
                          _obscure = !_obscure;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
