import 'package:flutter/material.dart';
import 'package:word_toob/views/widgets/bottom_sheet.dart';

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
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => BottomSheetContent(),
        );
      },
      child: Text("Help",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize)),
    );
  }
}
