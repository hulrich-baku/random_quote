import 'package:hive_flutter/hive_flutter.dart';
import '../model/quote.dart';
import 'package:share_plus/share_plus.dart';


class QuoteService {
  final _box = Hive.box<Quote>('QuoteBox');

  void saveQuote(Quote myQuote) {
    _box.add(myQuote);
  }

  void deleteQuote(int index){
    _box.deleteAt(index);
  }

  bool checkIfQuoteExists(Quote myQuote){
    return _box.values.any((quote)=> quote.text == myQuote.text);
  }

  void shareQuote(Quote myQuote){
    Share.share(
      "``${myQuote.text}`` - ${myQuote.author}",
      subject: "Partage de la citation"
    );
  }



}