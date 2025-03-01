import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:random_quote/model/quote.dart';
import 'package:random_quote/service/quote_service.dart';

class QuoteList extends StatefulWidget {
  const QuoteList({super.key});

  @override
  State<QuoteList> createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {

  final Box<Quote> _box = Hive.box<Quote>('QuoteBox');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Citations sauvegardées"), centerTitle: true,),
      body: ValueListenableBuilder(
        valueListenable: _box.listenable(), 
        builder: (context, Box<Quote> box, _){
          if (box.isEmpty){
            return Center(child: Text("Aucune citation enregistrée"),);
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index){
              final quote = box.getAt(index);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(quote!.text),
                  subtitle: Text(quote.author),
                  trailing: IconButton(
                    onPressed: (){
                      QuoteService().deleteQuote(index);
                    }, 
                    icon: Icon(Icons.delete, color: Colors.red,)
                  ),
                ),
              );
            }
          );
        }
      ),
    );
  }
}