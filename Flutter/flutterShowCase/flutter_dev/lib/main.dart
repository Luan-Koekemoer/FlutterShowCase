import 'package:flutter/material.dart';
import 'package:flutter_dev/views/colour_changer.dart';
import 'package:flutter_dev/views/scientific_calculator_api.dart';
import 'package:flutter_dev/views/paint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget _buildNavButton(context, textTo, pageToNav){
    return ElevatedButton(onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => pageToNav))},
                          child: Text(textTo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              _buildNavButton(context, "Colour Changer", const ColourChanger()),
              _buildNavButton(context, "Scientific Calculator", const ScientificCalculator()),
              _buildNavButton(context, "Paint App", const PaintApp())
            ],
          )
        ],
      ),
    );
  }
}
