import 'package:hive_flutter/hive_flutter.dart';
import '../model/quote.dart';


class QuoteService {
  final _box = Hive.box<Quote>('QuoteBox');

  void saveQuote(Quote myQuote) {
    _box.add(myQuote);
  }

  void deleteQuote(int index){
    _box.deleteAt(index);
  }

}