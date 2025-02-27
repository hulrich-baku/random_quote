import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  bool _clickedButton = false; // vérificateur du bouton cliqué
  final Dio dio = Dio(); // creation d'un objet Dio pour faire des requetes http
  Map<String,String>? varData; // variable recepteur des données venant de l'api
  final _translator = GoogleTranslator(); // l'objet traducteur (googleTranslator)
  
  // fonction pour obtenir les données dans l'api et ls traduire directement en français
  Future<Map<String,String>?> _getQuoteFromApi() async{
    try {
      final response = await dio.get("https://api.breakingbadquotes.xyz/v1/quotes");
      // Model Api Data
      // [ { "quote" : "this is a quote in English", "author" : "Hulrich Baku" } ]

      List dataQuote = response.data;   

      String quote = dataQuote[0]["quote"]; // quote 
      String author = dataQuote[0]["author"]; // author


      var quoteTranslated = await _translator.translate(quote, to:"fr") ;

      Map<String,String> result = {
        "quote" : quoteTranslated.toString(),
        "author" : author
      };

      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Random Quote")), backgroundColor:  Color.fromARGB(205, 33, 149, 243), foregroundColor: Colors.white,),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.list),
      ),
      body: StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged.map((result){
          if (result.contains(ConnectivityResult.none) || result.isEmpty){ // pas de connexion détectée
            return ConnectivityResult.none;
          } else {
            // connection détecté (Wifi, mobile, ethernet, other)
            return result.first;
          }
        }),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.active && snapshot.hasData){

            final connectivityResult = snapshot.data;

            // affichage du snackbar pour alerter que la connection n'est pas active
            if (connectivityResult == ConnectivityResult.none){
              WidgetsBinding.instance.addPostFrameCallback((_){
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.error_outline, color: Colors.white,),
                        Text("Veuillez vérifiez votre connexion", textAlign: TextAlign.center,),
                      ],
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1600),
                  )
                );
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_){
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              });
            }
          }
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color.fromARGB(171, 238, 233, 239), const Color.fromARGB(205, 33, 149, 243) ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(223, 248, 243, 243),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: _clickedButton? CircularProgressIndicator(color: const Color.fromARGB(241, 13, 94, 161),) : Column(
                      spacing: 2,
                      children: [
                      if (varData != null) ...[
                        Text(varData!["quote"]!, textAlign: TextAlign.center,style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                        Text("- ${varData!["author"]!} -", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17, color: const Color.fromARGB(255, 1, 89, 242)),)
                        ] else Text("La citation apparaitra ici!")
                    ],))
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: !_clickedButton ? () async {
                      setState(() {
                        _clickedButton = !_clickedButton;
                      });
                      varData = await _getQuoteFromApi();
                      setState(() {
                        _clickedButton = !_clickedButton;
                        varData;
                      });
                    } : null,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      side: BorderSide(color: const Color.fromARGB(255, 18, 21, 24)),
                      iconSize: 20,
                      backgroundColor: Colors.black26,
                    ),
                    label: Text("Rechercher une citation", style :TextStyle(color: Colors.white, fontSize: 16.2)),
                    icon: Icon(Icons.search, color: Colors.white),
                  ),
                )
            ]),
          );
        }
      ),
    );
  }

}
/**
 * Cette api donne les citations d'une serie
 * htpps://api.breakingbadquotes.xyz/v1/quotes   // Free API - Serie Citations
 * 
 */