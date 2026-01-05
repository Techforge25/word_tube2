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
    // Placeing the title value to the textfield so it can be editable.
    // Reason: To adding this code here because we didn't find the getter function in the init state.
    value.boradTitleController.text = value.gridSizedModel.title ?? "";

    return Text(
      value.gridSizedModel.title ?? "",
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.bold, fontSize: fontSize),
    );
  }
}
