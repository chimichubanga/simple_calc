import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple calc',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget{
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = _calculateResult();
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _input += value;
      }
    });
  }

  String _calculateResult() {
    return _input.isNotEmpty ? _eval(_input) : '0';
  }

  String _eval(String expression) {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(expression);
      ContextModel contextModel = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, contextModel);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  Widget _buildButton(String text) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        child: Text(text, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                _input,
                style: const TextStyle(
                    fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Text(
              _result,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Column(
              children: [
                Row(children: ['7', '8', '9', '/'].map(_buildButton).toList()),
                Row(children: ['4', '5', '6', '*'].map(_buildButton).toList()),
                Row(children: ['1', '2', '3', '-'].map(_buildButton).toList()),
                Row(children: ['C', '0', '=', '+'].map(_buildButton).toList()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}