
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:technical/models/phone_model.dart';
import 'package:technical/utils/database_helper.dart';

class PhoneRepository {
  getAllPhones() async {
    try {
      Database db = await DataBaseHelper.instance.database;
      var result = await db.query('phones', orderBy: 'id');
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  getAllPhonesFromContact(int id) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      var result = await db
          .query('phones', orderBy: 'id', where: 'FK_contact_id = ?', whereArgs: [id]);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  insertPhone(List<Phone> phones) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      Batch batch = db.batch();
      // ignore: avoid_function_literals_in_foreach_calls
      phones.forEach(
        (element) => batch.insert(
          'phones',
          element.toJson(),
        ),
      );
      var result = await batch.commit();
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  deletePhone(int id) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      var result = await db.delete('phones', where: 'id = ?', whereArgs: [id]);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  updatePhone(Map<String, dynamic> phone) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      var result = await db
          .update('phones', phone, where: 'id = ?', whereArgs: [phone['id']]);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }
}
