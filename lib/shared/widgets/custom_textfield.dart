import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.prefixIcon,
    this.sideWidget,
    this.isExpandable = false,
    this.isEditable = true,
  });

  final String? label;
  final String hintText;
  final TextInputType keyboardType;
  final double? width;
  final double? height;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? sideWidget;
  final bool isExpandable;
  final bool isEditable;

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
        !widget.isEditable
            ? Container(
                width: widget.width ?? double.infinity,
                height: widget.height ?? 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: theme.colorScheme.primary.withOpacity(.2),
                  ),
                ),
                padding: EdgeInsets.only(left: 10, right: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.hintText,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    if (widget.hintText != 'N/A') const SizedBox(width: 10),
                    if (widget.hintText != 'N/A')
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: widget.hintText),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              margin: EdgeInsetsGeometry.all(10),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              content: Text('Copied to clipboard'),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                          size: 20,
                          color: theme.colorScheme.onSurface.withOpacity(.7),
                        ),
                      ),
                  ],
                ),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: widget.width ?? double.infinity,
                      height: widget.height ?? 50,
                      child: TextField(
                        enabled: widget.isEditable,
                        controller: widget.controller,
                        keyboardType: widget.keyboardType,
                        expands: widget.isExpandable,
                        maxLines: widget.isExpandable ? null : 1,
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
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          prefixIcon: widget.prefixIcon,
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
                  ),

                  if (widget.sideWidget != null) ...[
                    const SizedBox(width: 10),
                    widget.sideWidget!,
                  ],
                ],
              ),
      ],
    );
  }
}
