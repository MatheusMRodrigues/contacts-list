import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:technical/utils/database_helper.dart';

class ContactRepository {
  getAllContacts() async {
    try {
      Database db = await DataBaseHelper.instance.database;
      String query =  'SELECT c.*, group_concat(p.phone) as phones FROM contacts as c INNER JOIN phones as p ON p.FK_contact_id = c.id GROUP BY c.id ORDER BY c.name';
      var result = await db.rawQuery(query);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  getAllContactsWithPagination(int page) async {
    int perPage = 4;
    try {
      Database db = await DataBaseHelper.instance.database;
      String queryPages =  'SELECT COUNT(*) AS total, CAST(COUNT(*) as FLOAT)/? as total_pages FROM contacts as c';
      var resultPages = await db.rawQuery(queryPages, [perPage]);
      Logger().wtf(resultPages);
      int totalPages = double.parse(jsonEncode(resultPages[0]['total_pages'])).ceil();
      Logger().wtf(totalPages);
      if(page < 1) {
        page = 1;
      }else if(page > totalPages) {
        return [];
      }
      var offset = (page - 1) * perPage;
      String query =  'SELECT c.*, group_concat(p.phone) as phones FROM contacts as c INNER JOIN phones as p ON p.FK_contact_id = c.id GROUP BY c.id ORDER BY c.name LIMIT ? OFFSET ?';
      var result = await db.rawQuery(query, [perPage, offset]);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  searchContacts(String keyword) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      String query =  'SELECT c.*, group_concat(p.phone) as phones FROM contacts as c INNER JOIN phones as p ON p.FK_contact_id = c.id WHERE c.name LIKE ? OR p.phone LIKE ? GROUP BY c.id ORDER BY c.name';
      var result = await db.rawQuery(query, ['%$keyword%', '%$keyword%']);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  insertContact(Map<String, dynamic> contact) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      var result = await db.insert('contacts', contact);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  deleteContact(int id) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      var result =
          await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }

  updateContact(Map<String, dynamic> contact) async {
    try {
      Database db = await DataBaseHelper.instance.database;
      var result = await db.update('contacts', contact,
          where: 'id = ?', whereArgs: [contact['id']]);
      return result;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }
}
