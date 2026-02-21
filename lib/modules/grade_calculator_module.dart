import 'package:flutter/material.dart';
import 'tool_module.dart';

// STEP 2 - Concrete Module: GradeCalculatorModule
// This class extends ToolModule (Step 1).
//
// TODO (Steps 3-4): Replace buildBody() with a full StatefulWidget that has
//   private fields (_components, _weights, _finalGrade),
//   a compute() method, a reset() method, and all required widgets
//   including a ListView for the grade component rows.

class GradeCalculatorModule extends ToolModule {
  @override
  String get title => 'Grade Calculator';

  @override
  IconData get icon => Icons.school_outlined;

  // TODO: Replace this placeholder with your complete UI widget.
  @override
  Widget buildBody(BuildContext context) => const _GradeStudent();
}

class _GradeStudent extends StatefulWidget {
  const _GradeStudent();
  @override
  State<_GradeStudent> createState() => _GradeStudentState();
}

class _GradeStudentState extends State<_GradeStudent> {
  final TextEditingController _scoreController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _finalGrade = 0;

  void compute() {
    double? score = double.tryParse(_scoreController.text);
    double? scoreWeight = double.tryParse(_weightController.text);

    if (score == null || scoreWeight == null || scoreWeight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid numbers 😅")),
      );
      return;
    }

    setState(() {
      _finalGrade = score * (scoreWeight / 100);
    });
  }
  void reset() {
    setState(() {
      _scoreController.text = "";
      _weightController.text = "";
      _finalGrade = 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Enter your component score and weight (%)"),
          const SizedBox(height: 10),
          TextField(
            controller: _scoreController,
            decoration: const InputDecoration(labelText: "Score"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _weightController,
            decoration: const InputDecoration(labelText: "Weight (%)"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(onPressed: compute, child: const Text("Compute")),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: reset, child: const Text("Reset")),
            ],
          ),
          const SizedBox(height: 16),
          Text("Final grade: ${_finalGrade.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}