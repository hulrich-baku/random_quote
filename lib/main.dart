import 'package:flutter/material.dart';
import 'package:random_quote/screens/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/quote.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // initialisation de Hive et ouverture d ela boite
  await Hive.initFlutter();
  Hive.registerAdapter(QuoteAdapter());
  await Hive.openBox<Quote>('QuoteBox');
  
  runApp(const MyApp());
  /* TODO : Résoudre l'erreur qui se trouve dans le fichier main.dart
  * FIXME : installer deux dependances (dev_depencies) dans le fichier pubspec.yam
  * NOTE : hive_generator et build_runner ensuite executer la commande pour générer
  *        les fichiers hive
  ```bash
    flutter pub run build_runner build
  ```
  */
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}