
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technical/controllers/contact_controller.dart';
import 'package:technical/utils/palette.dart';
import 'package:technical/views/contact.dart';
import 'package:technical/widgets/contact_card_painter.dart';

class ContactCard extends StatelessWidget {
  final int id;
  final ImageProvider? avatar;
  final String name;
  final String zipCode;
  final String city;
  final String state;
  final String address;
  final String number;
  final String complement;

  final Function onDelete;

  const ContactCard(
      {Key? key, required this.id, required this.name, required this.avatar, required this.zipCode, required this.city, required this.state, required this.address, required this.number, required this.complement, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContactController contactController = Get.find<ContactController>();

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
                children: [
                  const Icon(Icons.edit_outlined),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.defaultDialog(
                          title: 'Deseja realmente excluir:',
                          middleText: name,
                          textConfirm: 'Sim',
                          textCancel: 'Não',
                          confirmTextColor: Palette.white,
                          onConfirm: () async {
                            await contactController.removeContact(id);
                            onDelete(id);
                            Get.back();
                          });
                    },
                    child: const Icon(Icons.delete_outline_outlined),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => ContactView(
                      id: id,
                      avatar: avatar,
                      name: name,
                      zipCode: zipCode,
                      city: city,
                      state: state,
                      address: address,
                      number: number,
                      complement: complement,
                    ),
                  );
                },
                child: Stack(
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
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
