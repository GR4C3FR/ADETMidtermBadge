import 'package:flutter/material.dart';
import 'tool_module.dart';

// 
// STEP 2  Concrete Module: BmiModule
// 
// This class extends ToolModule (Step 1).
// It provides the required title and icon for the tab bar,
// and a buildBody() that returns the UI for the BMI Checker screen.
//
// TODO (Steps 34): Replace the placeholder buildBody() with a full
//   StatefulWidget that has private fields (_height, _weight, _result),
//   a compute() method, a reset() method, and all required widgets.
// 

class BmiModule extends ToolModule {
  @override
  String get title => 'BMI Checker';

  @override
  IconData get icon => Icons.monitor_weight_outlined;

  // TODO: Replace this placeholder with your complete UI widget.
  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement buildBody
    return const _BmiStudent();
  }
}
class _BmiStudent extends StatefulWidget {
  const _BmiStudent();
  @override
  State<_BmiStudent> createState() => _BmiStudentState();
}
class _BmiStudentState extends State<_BmiStudent> {
  final TextEditingController _height =TextEditingController();
  final TextEditingController _weight =TextEditingController();
  double? _bmiValue;
  String _bmiMsg = "";
  void compute() {
    double? h = double.tryParse(_height.text);
    double? w = double.tryParse(_weight.text);
    if (h ==null||w ==null) {
      ScaffoldMessenger.of(context).showSnackBar(const
      SnackBar(content:Text("Enter number pls")),);
      return;
    }
    if (h <= 0|| w <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const 
      SnackBar(content: Text("Entered number must be above 0")),);
      return;
    }
    setState(() {
      _bmiValue = w /((h /100)*(h/100));
      if (_bmiValue! < 18.5){ _bmiMsg ="Underweight";}
      else if (_bmiValue! < 25) {_bmiMsg ="Normal";}
      else if (_bmiValue! < 30) {_bmiMsg ="Overweight";}
      else {_bmiMsg ="obese";}
      print("BMI: $_bmiValue \n Category: $_bmiMsg");
    });
  }
  void reset(){
    setState(() {
      _height.text ="";
      _weight.text ="";
      _bmiValue = null;
      _bmiMsg = "";
    });
   }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hi! Fill in your height & weight (cm/kg)"),
          const SizedBox(height: 10),
          TextField(
            controller: _height,
            decoration: const InputDecoration(labelText: "Height"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _weight,
            decoration: const InputDecoration(labelText: "Weight"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton(onPressed: compute, child: const Text("Compute")),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: reset, child: const Text("Reset")),
            ],
          ),
          const SizedBox(height: 16),
          if (_bmiValue!= null)
            Text(
              "Your BMI is ${_bmiValue!.toStringAsFixed(1)} ($_bmiMsg)",
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}