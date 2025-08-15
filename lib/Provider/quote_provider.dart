import 'dart:math';

import 'package:daily_quotes/model/quote_model.dart';
import 'package:flutter/cupertino.dart';

import '../services/quote_service.dart';
import '../services/storage_service.dart';

class  QuoteProvider with ChangeNotifier {
  bool isLiked = false;
  bool isSaved = false;
  Quote ? _quote;
  bool _loading = false;
  String? _error;
  List<Quote> _history = [];
  final _offlineQuotes = [
    Quote(content: "Stay hungry, stay foolish.", author: "Steve Jobs"),
    Quote(content: "Code. Sleep. Repeat.", author: "Anonymous"),
    Quote(content: "Small steps, big results.", author: "Anonymous"),
    Quote(content: "Focus on the process, not the prize.", author: "Anonymous"),
  ];

  Quote? get quote => _quote;

  bool get loading => _loading;

  String? get error => _error;

  List<Quote> get history => _history;


  Future<void> loadHistory() async {
    _history = await StorageService.gethistory();
    notifyListeners();
  }

  Future<void> getRandomQuote() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final q = await QuoteService.fetchQuote();
      _quote = q;
    }
    catch (e) {
      _quote = _offlineQuotes[Random().nextInt(_offlineQuotes.length)];
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> deleteQuote(int index) async {
    await StorageService.deleteQuote(index);
    await loadHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await StorageService.clearHistory();
    await loadHistory();
    notifyListeners();
  }

  void toggleLike() {
    isLiked = !isLiked;
    notifyListeners();
  }

  void toggleSave() async {
    if(_quote == null) return;

    isSaved = !isSaved;

    if(isSaved){
      await StorageService.saveQuote(_quote!);
    }
    else{
      await StorageService.deleteQuote(_quote!.hashCode);
    }
    await loadHistory();
    notifyListeners();
  }

  void resetStates() {
    isLiked = false;
    isSaved = false;
    notifyListeners();
  }

}




