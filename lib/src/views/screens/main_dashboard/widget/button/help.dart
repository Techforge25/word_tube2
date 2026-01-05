import 'package:flutter/material.dart';
import 'package:word_toob/src/common/app_constants/route_strings.dart';

class HelpButton extends StatelessWidget {
  const HelpButton({
    super.key,
    required this.fontSize,
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(RouteStrings.helpScreen);
      },
      child: Text("Help",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize)),
    );
  }
}
