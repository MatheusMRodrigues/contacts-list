import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:technical/controllers/contact_controller.dart';
import 'package:technical/models/contact_model.dart';
import 'package:technical/shared/functions.dart';
import 'package:technical/widgets/contact_card.dart';

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  State<ContactsList> createState() => ContactsListState();
}

class ContactsListState extends State<ContactsList> {
  final ContactController contactController = Get.find<ContactController>();

  final ScrollController _scrollController = ScrollController();

  List<Contact> contactsList = [];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // ignore: prefer_typing_uninitialized_variables
  var listRequestReturn;

  scrollListenerHandler(bool enable) {
    if (enable) {
      _scrollController.addListener(paginationHandler);
      return;
    }
    _scrollController.removeListener(paginationHandler);
  }

  paginationHandler() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      listRequestReturn = await contactController
          .loadAllContactsWithPagination(++contactController.scrollPage.value);
      if (listRequestReturn == []) {
        contactController.scrollPage.value--;
      }
    }
  }

  onEndSearch() {
    scrollListenerHandler(true);
    clearAllContacts();
    contactController.loadAllContactsWithPagination(1, true);
  }

  clearAllContacts() {
    for (var i = 0; i <= contactsList.length - 1; i++) {
      _listKey.currentState!.removeItem(0,
          (BuildContext context, Animation<double> animation) {
        return Container();
      });
    }
    contactsList.clear();
  }

  contactsListHandler(double width, bool remove, [int? id]) {
    if (contactController.isLoadingContacts.value) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (remove) {
      int indexOfContact =
          contactsList.indexWhere((element) => element.id == id);
      _listKey.currentState!.removeItem(
        indexOfContact,
        (context, animation) => buildListItem(
          contactsList[indexOfContact],
          animation,
          width,
        ),
      );
      Future.delayed(const Duration(milliseconds: 150), () {
        contactsList.removeWhere((element) => element.id == id);
      });
      return;
    }
    if (contactController.contacts.isNotEmpty) {
      if (contactController.isSearchingContacts.value) {
        clearAllContacts();
        scrollListenerHandler(false);
      }
      Future future = Future(() {});
      // ignore: avoid_function_literals_in_foreach_calls
      contactController.contacts.forEach((element) {
        future = future.then((_) {
          return Future.delayed(const Duration(milliseconds: 150), () {
            if (!contactsList.any((contact) => contact.id == element.id)) {
              contactsList.add(element);
              _listKey.currentState!.insertItem(contactsList.length - 1);
            }
          });
        });
      });

      return Scrollbar(
        child: AnimatedList(
          key: _listKey,
          controller: _scrollController,
          padding: const EdgeInsets.only(top: 15.0, bottom: 30.0),
          // separatorBuilder: (context, index) {
          //   return SizedBox(
          //     height: MediaQuery.of(context).size.height * 0.025,
          //   );
          // },
          initialItemCount: contactsList.length,
          itemBuilder: (context, index, animation) {
            return buildListItem(contactsList[index], animation, width);
          },
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/emptyContactsList.png',
          width: width * 0.3,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Não há contatos',
          style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(
              fontSize: width * 0.05,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  buildListItem(Contact contact, Animation animation, double width) {
    Tween<Offset> offset =
        Tween(begin: const Offset(1, 0), end: const Offset(0, 0));
    return SlideTransition(
      position: animation.drive(offset),
      child: Column(
        children: [
          Hero(
            tag: 'contactCard${contact.id!}',
            child: Material(
              type: MaterialType.transparency,
              child: ContactCard(
                id: contact.id!,
                avatar: decodeAvatar(contact.avatar),
                name: contact.name!,
                zipCode: contact.zipCode!,
                city: contact.city!,
                state: contact.state!,
                address: contact.address!,
                number: contact.number!,
                complement: contact.complement!,
                onDelete: (id) {
                  contactsListHandler(width, true, id);
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    scrollListenerHandler(true);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.transparent,
            Colors.transparent,
            Colors.white
          ],
          stops: [0.0, 0.07, 0.9, 1.0], // 10% white, 80% transparent, 10% white
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Obx(
        () {
          return contactsListHandler(MediaQuery.of(context).size.width, false);
        },
      ),
    );
  }
}
