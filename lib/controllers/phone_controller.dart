
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:technical/models/contact_model.dart';
import 'package:technical/models/phone_model.dart';
import 'package:technical/respositorys/phone_repository.dart';

class PhoneController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<Phone> phones = <Phone>[].obs;

  loadAllPhones([bool? refresh]) async {
    refresh ?? isLoading(true);
    try {
      var getPhones = await PhoneRepository().getAllPhones();
      phones.value = getPhones.isNotEmpty
          ? getPhones.map<Phone>((element) => Phone.fromJson(element)).toList()
          : [];
      // Timer(const Duration(milliseconds: 1500), () => isLoading(false));
      Logger().i(getPhones);
      return;
    } catch (e) {
      // Timer(const Duration(milliseconds: 1500), () => isLoading(false));
      Logger().e(e);
      rethrow;
    }
  }

  loadAllPhonesFromContact(int id, [bool? refresh]) async {
    refresh ?? isLoading(true);
    try {
      var getPhones = await PhoneRepository().getAllPhonesFromContact(id);
      phones.value = getPhones.isNotEmpty
          ? getPhones.map<Phone>((element) => Phone.fromJson(element)).toList()
          : [];
      // Timer(const Duration(milliseconds: 1500), () => isLoading(false));
      Logger().i(getPhones);
      return;
    } catch (e) {
      // Timer(const Duration(milliseconds: 1500), () => isLoading(false));
      Logger().e(e);
      rethrow;
    }
  }

  // savePhone(Contact contact) async {
  //   try {
  //     var savePhone = await PhoneRepository().insertPhone(contact.toJson());
  //     Logger().i(savePhone);
  //     return;
  //   } catch (e) {
  //     Logger().e(e);
  //     rethrow;
  //   }
  // }

  removePhone(int id) async {
    try {
      var removePhone = await PhoneRepository().deletePhone(id);
      Logger().i(removePhone);
      return;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  editPhone(Contact contact) async {
    try {
      var editContact = await PhoneRepository().updatePhone(contact.toJson());
      Logger().i(editContact);
      return;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  
}
