import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  bool _clickedButton = false; // vérificateur du bouton cliqué
  final Dio dio = Dio(); // creation d'un objet Dio pour faire des requetes http
  dynamic varData; // variable recepteur des données venant de l'api
  
  // fonction pour obtenir les données dans l'api
  _getQuoteFromApi() async{
    try {
      final response = await dio.get("https://api.breakingbadquotes.xyz/v1/quotes");
      List dataQuote = response.data;
      return dataQuote;
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
              spacing: 15,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(165, 236, 231, 231),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: _clickedButton? CircularProgressIndicator() : Column(
                      spacing: 15,
                      children: [
                      if (varData != null) ...[
                        Text(varData[0]["quote"], textAlign: TextAlign.center,),
                        Text(varData[0]["author"], style: TextStyle(fontWeight: FontWeight.bold),)
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
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      side: BorderSide(color: const Color.fromARGB(255, 18, 21, 24)),
                      iconSize: 20,
                      backgroundColor: Colors.black26,
                      iconColor: Colors.white,
                    ),
                    label: Text("Rechercher une citation", style :TextStyle(color: Colors.white)),
                    icon: Icon(Icons.search),
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