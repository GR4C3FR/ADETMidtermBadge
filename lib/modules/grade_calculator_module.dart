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
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text(
        'Grade Calculator\n\nUI goes here - implement in Steps 3 & 4.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color(0xFF007BFF)),
      ),
    );
  }
}
