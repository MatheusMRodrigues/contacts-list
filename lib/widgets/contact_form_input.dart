import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactFormInput extends StatelessWidget {

  final String label;
  final bool centeredLabel;
  final int? maxLenght;
  final TextEditingController controller;
  final TextInputType textInputType;
  final TextInputMask? textInputMask;

  const ContactFormInput({Key? key, required this.label, required this.centeredLabel, required this.controller, this.maxLenght, required this.textInputType, this.textInputMask}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: textInputMask != null ? [textInputMask!] : [],
      maxLength: maxLenght,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        hintText: label,
        hintStyle: GoogleFonts.nunitoSans(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),
      style: GoogleFonts.nunitoSans(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
      textAlign: centeredLabel ? TextAlign.center : TextAlign.start,
    );
  }
}
