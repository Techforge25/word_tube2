import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ToolTipWidget extends StatelessWidget {

  const ToolTipWidget({
    super.key,
    required SuperTooltipController controller, required this.widget, required this.content,
  }) : _controller = controller;

  final SuperTooltipController _controller;
  final Widget widget;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return SuperTooltip(

        showBarrier: true,
        controller: _controller,
        content:content,
        child:widget);
  }
}
