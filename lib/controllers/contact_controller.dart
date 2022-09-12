import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:technical/models/contact_model.dart';
import 'package:technical/models/phone_model.dart';
import 'package:technical/respositorys/contact_repository.dart';
import 'package:technical/respositorys/phone_repository.dart';

class ContactController extends GetxController {
  RxBool isLoadingContacts = false.obs;

  RxBool isSearchingContacts = false.obs;

  RxList<Contact> contacts = <Contact>[].obs;

  RxInt scrollPage = 1.obs;

  loadAllContacts([bool? refresh]) async {
    isLoadingContacts(true);
    try {
      var getContacts = await ContactRepository().getAllContacts();
      contacts.value = getContacts.isNotEmpty
          ? getContacts
              .map<Contact>((element) => Contact.fromJson(element))
              .toList()
          : [];
      Logger().i(getContacts);
      isLoadingContacts(true);
      return;
    } catch (e) {
      Logger().e(e);
      isLoadingContacts(false);
      rethrow;
    }
  }

  loadAllContactsWithPagination(int page, [bool? refresh]) async {
    isSearchingContacts(false);
    isLoadingContacts(page == 1 ? true : false);
    if (refresh != null && refresh) {
      scrollPage.value = 1;
      contacts.clear();
    }
    try {
      var getContacts =
          await ContactRepository().getAllContactsWithPagination(page);
      if (getContacts.isEmpty) {
        isLoadingContacts(false);
        return [];
      }
      contacts.addAll(getContacts
          .map<Contact>((element) => Contact.fromJson(element))
          .toList());
      Logger().i(getContacts);
      isLoadingContacts(false);
      return;
    } catch (e) {
      Logger().e(e);
      isLoadingContacts(false);
      rethrow;
    }
  }

  searchContacts(String keyword) async {
    isSearchingContacts(true);
    try {
      if (keyword.isEmpty) {
        loadAllContactsWithPagination(1, true);
      }
      var searchContacts = await ContactRepository().searchContacts(keyword);
      contacts.clear();
      contacts.addAll(searchContacts
          .map<Contact>((element) => Contact.fromJson(element))
          .toList());
      Logger().i(searchContacts);
      return;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  saveContact(Contact contact, List<Phone> phones) async {
    try {
      var saveContact =
          await ContactRepository().insertContact(contact.toJson());
      List<Phone> phonesWithId = phones
          .map<Phone>(
              (element) => Phone(phone: element.phone, contact: saveContact))
          .toList();
      var savePhones = await PhoneRepository().insertPhone(phonesWithId);
      Logger().i(saveContact);
      Logger().i(savePhones);
      return;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  removeContact(int id) async {
    try {
      var removeContact = await ContactRepository().deleteContact(id);
      contacts.removeWhere((element) => element.id == id);
      Logger().i(removeContact);
      return;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  editContact(Contact contact) async {
    try {
      var editContact =
          await ContactRepository().updateContact(contact.toJson());
      Logger().i(editContact);
      return;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }
}
