import 'dart:ffi';

import 'package:flutter/material.dart';
import 'button_values.dart';
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  var number1="";
  var operand="";
  var number2="";
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(16),
                  child: Text("$number1$operand$number2".isEmpty ? "0" : "$number1$operand$number2",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 65,
                  ),
                  ),
                ),
              ),
            ),

            // buttons
            Wrap(
              children:
                Btn.buttonValues.map((value) => SizedBox(
                    width: value==Btn.n0 ? screenSize.width/2 : screenSize.width/4,
                    height: screenSize.width/5,
                    child: buildButton(value))).toList(),
            )
            
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.blueGrey,
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(100)
        ),
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(child: Text(value,style: TextStyle(fontSize: 26,color: value==Btn.clr ? Colors.redAccent:Colors.white),))),
      ),
    );
  }

  onBtnTap(value) {
    if(value == Btn.del){
      delete();
      return;
    }
    if(value== Btn.clr){
      clear();
      return;
    }
    if(value== Btn.per){
      percentage();
      return;
    }
    if(value==Btn.calculate){
      calulate();
      return;
    }

    appendValues(value);

  }

  void appendValues(value) {
    if(value!=Btn.dot && int.tryParse(value)==null) {
      if(operand.isNotEmpty && number2.isNotEmpty){
        calulate();
      }
      operand = value;
    }
    else if(number1.isEmpty || operand.isEmpty){
      if(value == Btn.dot && number1.contains(Btn.dot)) return;
      if(value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)){
        value="0.";
      }
      number1+=value;
    }
    else if(number2.isEmpty || operand.isNotEmpty){
      if(value == Btn.dot && number2.contains(Btn.dot)) return;
      if(value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)){
        value="0.";
      }
      number2+=value;
    }
    setState(() {});
  }

  void delete() {
    if(number2.isNotEmpty){
      number2=number2.substring(0,number2.length-1);
    }
    else if(operand.isNotEmpty){
      operand="";
    }
    else if(number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {});
  }

  void clear() {
    setState(() {
      number1="";
      operand="";
      number2="";
    });

  }

  void percentage() {
    final number = double.parse(number1);
    if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){
      calulate();
    }
    else if(operand.isNotEmpty){
      return;
    }
    else if(number1.isNotEmpty){
      number1 = "${number/100}";
      operand="";
      number2="";
    }
    setState(() {});
  }

  void calulate() {
    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);
    var result=0.0;
    switch (operand) {
      case (Btn.add):
        result = num1 + num2;
        break;
      case (Btn.subtract):
        result = num1 - num2;
        break;
      case (Btn.multiply):
        result = num1 * num2;
        break;
      case (Btn.divide):
        result = num1 / num2;
        break;
    }

    setState(() {
      number1="$result";
      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);
      }
      operand="";
      number2="";
    });
  }
}
