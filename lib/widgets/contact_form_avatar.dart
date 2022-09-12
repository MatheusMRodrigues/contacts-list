import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:technical/utils/enums.dart';
import 'package:technical/utils/palette.dart';

class ContactFormAvatar extends StatefulWidget {
  final Function onImageSelected;

  const ContactFormAvatar({Key? key, required this.onImageSelected})
      : super(key: key);

  @override
  State<ContactFormAvatar> createState() => _ContactFormAvatarState();
}

class _ContactFormAvatarState extends State<ContactFormAvatar> {
  XFile? contactImage;

  getContactPicture(ContactImageSource source) async {
    final ImagePicker picker = ImagePicker();
    if (source == ContactImageSource.Camera) {
      contactImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      setState(() {});
      Get.back();
      return widget.onImageSelected(contactImage);
    }
    contactImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {});
    Get.back();
    return widget.onImageSelected(contactImage);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            CircleAvatar(
              radius: constraints.maxWidth * 0.20,
              backgroundColor: Colors.grey,
              backgroundImage: contactImage != null
                  ? FileImage(File(contactImage!.path))
                  : const AssetImage('assets/avatar.png') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: constraints.maxWidth * 0.5,
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Palette.white,
                        boxShadow: [
                          BoxShadow(
                            color: Palette.black,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 10,
                              width: constraints.maxWidth * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Palette.lightGrey,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Abrir com',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                fontSize: constraints.maxWidth * 0.05,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () {
                                    getContactPicture(
                                        ContactImageSource.Camera);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                      Palette.pink,
                                    ),
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                        color: Palette.pink,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.camera_alt_outlined),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Camera',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            fontSize:
                                                constraints.maxWidth * 0.05,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.08,
                              ),
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () {
                                    getContactPicture(
                                        ContactImageSource.Gallery);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                      Palette.pink,
                                    ),
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                        color: Palette.pink,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.image_outlined),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Galeria',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            fontSize:
                                                constraints.maxWidth * 0.05,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: constraints.maxWidth * 0.06,
                  backgroundColor: Palette.pink,
                  child: Icon(
                    Icons.edit,
                    color: Palette.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
