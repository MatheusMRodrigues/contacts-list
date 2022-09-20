import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technical/controllers/contact_controller.dart';
import 'package:technical/models/contact_model.dart';
import 'package:technical/views/new_contact.dart';

class HomeHeader extends StatefulWidget {
  final Function onCloseSearch;

  const HomeHeader({Key? key, required this.onCloseSearch}) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final ContactController contactController = Get.find<ContactController>();

  bool isSearch = false;
  List<Contact> oldContacts = [];
  Timer? _debounce;
  TextEditingController searchController = TextEditingController();

  onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      contactController.searchContacts(searchController.text);
    });
  }

  homeHeaderHandler(BoxConstraints constraints) {
    if (isSearch) {
      return Row(
        key: const ValueKey<int>(0),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0),
                  isDense: true,
                  hintText: 'PESQUISAR CONTATO',
                  hintStyle: GoogleFonts.nunitoSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  border:
                      const OutlineInputBorder(borderSide: BorderSide.none)),
              style: GoogleFonts.nunitoSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                searchController.removeListener(onSearchChanged);
                isSearch = false;
                searchController.text = '';
                widget.onCloseSearch();
              });
            },
            iconSize: constraints.maxWidth * 0.1,
            splashRadius: constraints.maxWidth * 0.08,
            icon: const Icon(Icons.close),
          )
        ],
      );
    }
    return Row(
      key: const ValueKey<int>(1),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'CONTATOS',
          style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
              fontSize: constraints.maxWidth * 0.07,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  searchController.addListener(onSearchChanged);
                  isSearch = true;
                });
              },
              iconSize: constraints.maxWidth * 0.1,
              splashRadius: constraints.maxWidth * 0.08,
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => const NewContactView());
              },
              iconSize: constraints.maxWidth * 0.1,
              splashRadius: constraints.maxWidth * 0.08,
              icon: const Icon(Icons.add_circle_outline),
            )
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    oldContacts = contactController.contacts;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          const SizedBox(height: 20),
          AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: homeHeaderHandler(constraints)),
          const Divider(height: 6),
        ],
      );
    });
  }
}
