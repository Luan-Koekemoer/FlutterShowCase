import 'package:flutter/material.dart';

class ColourChanger extends StatefulWidget {
  const ColourChanger({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ColourChangerStateFull();
}

class _ColourChangerStateFull extends State<ColourChanger> {
  MaterialColor thisStateColour = Colors.green;

  void _setColourAction(color) {
    setState(() => thisStateColour = color);
  }

  Widget _buildColourChangerButton(colorNameStr, color) {
    ButtonStyle btnStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) => color),
        textStyle: MaterialStateProperty.resolveWith(
            (states) => const TextStyle(fontSize: 20)));

    String btnText =
        "Change to: ${colorNameStr} ${(color == thisStateColour ? "*" : "")}";
    return ElevatedButton(
        onPressed: () => _setColourAction(color),
        child: Text(btnText),
        style: btnStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colour Changer'),
        backgroundColor: thisStateColour,
      ),
      body: Center(
          child: Column(
        children: [
          _buildColourChangerButton("Green", Colors.green),
          _buildColourChangerButton("Red", Colors.red),
          _buildColourChangerButton("Blue", Colors.blue),
          _buildColourChangerButton("Pink", Colors.pink),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      )),
    );
  }
}

