import 'package:flutter/material.dart';
import 'package:word_toob/views/theme/app_color.dart';

class CustomMenuAnchor extends StatelessWidget {
  final List<Widget> menuItems;
  final Widget titleWidget;
  final Color backgroundColor;
  final MenuController? menuController;


   CustomMenuAnchor({
    Key? key,

    required this.menuItems,
    required this.titleWidget,  this.menuController,  this.backgroundColor=AppColor.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(


      controller: menuController,

      style: MenuStyle(


        backgroundColor: WidgetStateProperty.all(backgroundColor)
      ),
      builder: (context, controller, child) => GestureDetector(
        onTap: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            controller.open();
          }
        },
        child: titleWidget
      ),
      menuChildren:menuItems,
    );
  }
}


class CustomMenuItemButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;

  const CustomMenuItemButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(


      style: ButtonStyle(
        textStyle: WidgetStateProperty.resolveWith((states) => TextStyle(color: Colors.white),),

        padding:WidgetStateProperty.all(EdgeInsetsDirectional.all(10)),
        backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}


