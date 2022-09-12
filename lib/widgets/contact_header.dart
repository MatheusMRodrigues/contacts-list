import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technical/utils/palette.dart';
import 'package:technical/widgets/contact_card_painter.dart';

class ContactHeader extends StatelessWidget {
  final String name;
  final ImageProvider? avatar;
  final bool haveReminder;

  const ContactHeader(
      {Key? key, required this.name, this.avatar, required this.haveReminder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    getName() {
      if(name.split(' ').length > 1) {
        return '${name.split(' ')[0]} ${name.split(' ')[name.split(' ').length - 1]}';
      }
      return name;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.edit_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.delete_outline_outlined),
                    ],
                  ),
                  haveReminder
                      ? Row(
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: Palette.pink,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Lembrete ativo',
                              style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                  fontSize: constraints.maxWidth * 0.04,
                                  color: Palette.pink,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox()
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: -15,
                    bottom: -10,
                    child: Container(
                      height: 125,
                      width: constraints.maxWidth - 10,
                      color: const Color.fromRGBO(255, 180, 157, .7),
                    ),
                  ),
                  CustomPaint(
                    painter: ContactCardPainter(),
                    child: SizedBox(
                      height: 135,
                      width: constraints.maxWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: constraints.maxWidth * 0.12,
                                backgroundColor: Colors.grey,
                                backgroundImage: avatar,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                getName(),
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    fontSize: constraints.maxWidth * 0.06,
                                    color: Palette.black,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
