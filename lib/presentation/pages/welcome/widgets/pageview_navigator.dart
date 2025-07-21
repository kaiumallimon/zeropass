import 'package:flutter/material.dart';

class WelcomePageNavigator extends StatelessWidget {
  const WelcomePageNavigator({
    super.key,
    required this.theme,
    required this.index,
  });

  final ThemeData theme;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "1  ",
        style: TextStyle(
          color: index == 0
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(.5),
          fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,

          fontSize: index == 0 ? 30 : 20,
        ),
        children: [
          TextSpan(
            text: "2  ",
            style: TextStyle(
              color: index == 1
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.5),
              fontWeight: index == 1 ? FontWeight.bold : FontWeight.normal,
              fontSize: index == 1 ? 30 : 20,
            ),
          ),

          TextSpan(
            text: "3",
            style: TextStyle(
              color: index == 2
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(.5),
              fontWeight: index == 2 ? FontWeight.bold : FontWeight.normal,
              fontSize: index == 2 ? 30 : 20,
            ),
          ),
        ],
      ),
    );
  }
}
