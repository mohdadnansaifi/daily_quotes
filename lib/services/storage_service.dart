import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/quote_model.dart';


class StorageService{
  static const String _historyKey='quote history';

  static Future<void> saveQuote(Quote quote) async{
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];

    String quotejson = jsonEncode({
      'content': quote.content,
      'author': quote.author,
    });
    history.add(quotejson);
    await prefs.setStringList(_historyKey, history);

  }

  static Future<List<Quote>> gethistory() async{
    final prefs= await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ??[];

    return history.map((q){
      final data = jsonDecode(q);
      return Quote(content: data['content'], author: data['author']);
    }).toList();
  }

  static Future<void> deleteQuote(int index) async{
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    if(index >= 0 && index < history.length){
      history.removeAt(index);
      await prefs.setStringList(_historyKey, history);
    }
  }
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

}