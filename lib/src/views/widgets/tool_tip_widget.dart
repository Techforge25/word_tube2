import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

/// Widget that wraps content with a super tooltip
class ToolTipWidget extends StatelessWidget {
  final SuperTooltipController _controller;
  final Widget widget;
  final Widget content;

  const ToolTipWidget({
    super.key,
    required SuperTooltipController controller,
    required this.widget,
    required this.content,
  }) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      showBarrier: true,
      controller: _controller,
      content: content,
      child: widget,
    );
  }
}
