import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';
import '../Modals/LanguageModel.dart';

class AppLanguages {
  List<Map<String, dynamic>> languages = [];
  Future<void> loadLanguages() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> maps =
    await db.query(LanguageModel.tableName);
    languages = maps.map((lang) {
      String code = lang['language_code'];
      List<String> parts = code.split('_');
      return {
        'id': lang['language_id'],
        'name': lang['language_name'],
        'code': lang['language_code'],
        'locale': Locale(parts[0], parts.length > 1 ? parts[1] : ""),
      };
    }).toList();
  }
}
