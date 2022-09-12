import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technical/widgets/app_bar_action.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool action;
  final Function? actionFunction;
  final Icon? actionIcon;

  const CustomAppBar(
      {Key? key,
      required this.title,
      required this.action,
      this.actionFunction,
      this.actionIcon})
      : super(key: key);

  appBarAction(BoxConstraints constraints) {
    if (action) {
      return Flexible(
          child: AppBarAction(
        function: () {
          if(actionFunction != null) {
            actionFunction!();
          }
        },
        icon: actionIcon!,
        constraints: constraints,
      ));
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      iconSize: constraints.maxWidth * 0.1,
                      splashRadius: constraints.maxWidth * 0.06,
                      icon: const Icon(
                        Icons.arrow_circle_left_outlined,
                      ),
                    ),
                    Text(
                      title,
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          fontSize: constraints.maxWidth * 0.07,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
                appBarAction(constraints),
              ],
            ),
            const Divider(height: 6),
          ],
        );
      },
    );
  }
}
