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