import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/word.dart';
import '../utils/database_helper.dart';

class DictionaryController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Load dữ liệu từ JSON vào SQLite lần đầu
  Future<void> initializeData() async {
    final isEmpty = await _dbHelper.isDatabaseEmpty();
    if (isEmpty) {
      final jsonString = await rootBundle.loadString('assets/dictionary.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final words = jsonList.map((j) => Word(
        word: j['word'] as String,
        meaning: j['meaning'] as String,
      )).toList();
      await _dbHelper.insertWords(words);
    }
  }

  Future<List<Word>> searchWords(String query) async {
    if (query.trim().isEmpty) {
      return await _dbHelper.getAllWords();
    }
    return await _dbHelper.searchWords(query.trim());
  }
}
