import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Quote{

  @HiveField(0)
  String text;

  @HiveField(1)
  String author;

  Quote({required this.text, required this.author});

  factory Quote.fromMap(Map<String, String> map){
    return Quote(
      text: map["quote"] ?? "", 
      author: map["author"] ?? ""
    );
  }
}