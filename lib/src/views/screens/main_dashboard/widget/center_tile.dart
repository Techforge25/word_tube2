import 'package:flutter/material.dart';
import 'package:word_toob/src/app_providers/main_dashboard_controller.dart';

class CenterTitle extends StatelessWidget {
  final MainDashboardController value;
  final double fontSize;

  const CenterTitle({
    super.key,
    required this.value,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(value.gridSizedModel.title ?? "",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize)),
    );
  }
}
