import 'dart:convert';
import 'package:daily_quotes/model/quote_model.dart';
import 'package:http/http.dart' as http;

class QuoteService{
  static Future <Quote> fetchQuote() async {
    final res = await http.get(Uri.parse('https://zenquotes.io/api/random'));
    if(res.statusCode == 200){
      final List data = jsonDecode(res.body);
      return Quote.fromJson(data[0]);
    }
    else{
      print('Failed to load quote');
      throw Exception('Failed to load quote');
    }
  }
}