import 'package:flutter/material.dart';

class AppBarAction extends StatelessWidget {
  final Function? function;
  final Icon icon;
  final BoxConstraints constraints;

  const AppBarAction(
      {Key? key,
      required this.function,
      required this.icon,
      required this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if(function != null) {
          function!();
        }
      },
      iconSize: constraints.maxWidth * 0.1,
      splashRadius: constraints.maxWidth * 0.07,
      icon: icon,
    );
  }
}
