import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technical/controllers/contact_controller.dart';
import 'package:technical/controllers/phone_controller.dart';
import 'package:technical/widgets/contacts_list.dart';
import 'package:technical/widgets/home_header.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ContactController contactController = Get.put(ContactController());
  final PhoneController phoneController = Get.put(PhoneController());

  final GlobalKey<ContactsListState> _key = GlobalKey();

  @override
  void initState() {
    contactController.loadAllContactsWithPagination(1, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            children: [
              HomeHeader(
                onCloseSearch: () {
                  _key.currentState!.onEndSearch();
                },
              ),
              Expanded(
                child: ContactsList(key: _key),
              )
            ],
          ),
        ),
      ),
    );
  }
}
