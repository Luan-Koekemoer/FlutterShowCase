import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/calc.dart';
import 'dart:async';
import 'dart:convert';

class FunctionType {
  late String functionName;
  late Icon functionIcon;
  FunctionType(String name, Icon icon) {
    functionName = name;
    functionIcon = icon;
  }
}

Future<Calculation> fetchCalculation(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return Calculation.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to compute expression');
  }
}

class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({super.key});

  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  /* ScientificCalculator({Key? key}) : super(key: key); */
  late Future<Calculation> futureCalc;
  late List<FunctionType> functions;
  late FunctionType current;
  late String answer;
  late Future<Calculation> future;

  //API: https://github.com/aunyks/newton-api
  final String baseUrl = 'https://newton.now.sh/api/v2/';
  final inputController = TextEditingController();

  Future<Calculation> _computeInput() async {
    String inputBox = inputController.text;
    if (inputBox == "") {
      return fetchCalculation("$baseUrl/simplify/0");
    }
    inputBox = inputBox.replaceAll("/", "(over)");

    String url = "$baseUrl${current.functionName.toLowerCase()}/$inputBox";
    return fetchCalculation(url);
  }

  Widget _inputBox(Icon calcType) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Column(children: [
                TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    icon: calcType,
                    hintText: '',
                  ),
                ),
              ])),
        ]);
  }

  Widget _selectFunctionType() {
    return DropdownButton<String>(
      value: current.functionName,
      icon: const Icon(Icons.question_mark_rounded),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          current = functions[0]; // default setting
          for (var ft in functions) {
            if (ft.functionName == value) {
              current = ft;
              break;
            }
          }
        });
      },
      items: functions.map<DropdownMenuItem<String>>((FunctionType ft) {
        return DropdownMenuItem<String>(
          value: ft.functionName,
          child: Text(ft.functionName),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    super.initState();
    // Set function types
    FunctionType ft1 = FunctionType("Simplify",
        const Icon(Icons.calculate, size: 30.0, color: Colors.green));
    FunctionType ft2 = FunctionType("Derive",
        const Icon(Icons.device_hub, size: 30.0, color: Colors.green));
    FunctionType ft3 = FunctionType("Integrate",
        const Icon(Icons.functions, size: 30.0, color: Colors.green));
    FunctionType ft4 = FunctionType(
        "Factor",
        const Icon(Icons.emoji_objects_rounded,
            size: 30.0, color: Colors.green));

    functions = [ft1, ft2, ft3, ft4];
    current = functions[0];
    answer = "";
    future = _computeInput();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sci Calc'),
        ),
        body: Center(
          child: Column(children: [
            _inputBox(current.functionIcon),
            FutureBuilder<Calculation>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!.result,
                    style: const TextStyle(fontSize: 30, height: 1.5),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return (const CircularProgressIndicator());
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _selectFunctionType(),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: () {
                      setState(() => {future = _computeInput()});
                    },
                    child: const Text('Calculate'))
              ],
            ),
            Column(children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go back!'),
              ),
            ])
          ]),
        ));
  }
}
