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
    return const Center(
      child: Text(
        'BMI Checker\n\nUI goes here  implement in Steps 3 & 4.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color(0xFF007BFF)),
      ),
    );
  }
}
