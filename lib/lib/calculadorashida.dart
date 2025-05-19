import 'package:flutter/material.dart';

class CalculadoraShida extends StatefulWidget {
  const CalculadoraShida({Key? key}) : super(key: key);

  @override
  State<CalculadoraShida> createState() => _CalculadoraShidaState();
}

class _CalculadoraShidaState extends State<CalculadoraShida> {
  String input = '';
  String output = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        output = '';
      } else if (value == '=') {
        try {
          output = _evaluateExpression(input);
        } catch (e) {
          output = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  String _evaluateExpression(String expr) {
    List<String> tokens = [];
    String number = '';
    for (int i = 0; i < expr.length; i++) {
      if ('0123456789.'.contains(expr[i])) {
        number += expr[i];
      } else {
        if (number.isNotEmpty) {
          tokens.add(number);
          number = '';
        }
        tokens.add(expr[i]);
      }
    }
    if (number.isNotEmpty) tokens.add(number);
    for (int i = 0; i < tokens.length; i++) {
      if (tokens[i] == '*' || tokens[i] == '/') {
        double left = double.parse(tokens[i - 1]);
        double right = double.parse(tokens[i + 1]);
        double res = tokens[i] == '*' ? left * right : left / right;
        tokens[i - 1] = res.toString();
        tokens.removeAt(i);
        tokens.removeAt(i);
        i -= 1;
      }
    }
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      double right = double.parse(tokens[i + 1]);
      if (tokens[i] == '+') {
        result += right;
      } else if (tokens[i] == '-') {
        result -= right;
      }
    }

    if (result % 1 == 0) {
      return result.toInt().toString();
    } else {
      return result.toStringAsFixed(4);
    }
  }

  Widget buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          onPressed: () => buttonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 22),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 26,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black87],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          title: const Text("Calculadora", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff281537), Color(0xffac0f2d)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 5),
                  blurRadius: 15,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Text(
                    input,
                    style: const TextStyle(fontSize: 30, color: Colors.white70),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    output,
                    style: const TextStyle(fontSize: 42, color: Colors.white, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Divider(color: Colors.white54),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      children: [
                        buildButton('C', color: Colors.grey[700]),
                        buildButton('(', color: Colors.grey[700]),
                        buildButton(')', color: Colors.grey[700]),
                        buildButton('/', color: Color(0xffac0f2d), textColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton('7'),
                        buildButton('8'),
                        buildButton('9'),
                        buildButton('*', color: Color(0xffac0f2d), textColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton('4'),
                        buildButton('5'),
                        buildButton('6'),
                        buildButton('-', color: Color(0xffac0f2d), textColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton('1'),
                        buildButton('2'),
                        buildButton('3'),
                        buildButton('+', color: Color(0xffac0f2d), textColor: Colors.white),
                      ],
                    ),
                    Row(
                      children: [
                        buildButton('0', color: Colors.grey[850]),
                        buildButton('.', color: Colors.grey[850]),
                        buildButton('=', color: Color(0xff592c78), textColor: Colors.white),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
