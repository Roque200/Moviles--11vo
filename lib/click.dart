import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() =>  runApp(MyApp());

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int valor = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        body: Center(child: Text("Contador de Clicks: $valor", style: TextStyle(fontSize: 30, color: const Color.fromARGB(221, 30, 41, 188)),)),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black87,
          child: const Icon(Icons.add_circle_outline_sharp,color: Colors.blue, size: 50,),
          onPressed: (){
            valor++;
            setState(() {});
            print(valor);
          },
        ),
      )
    );
  }
} 