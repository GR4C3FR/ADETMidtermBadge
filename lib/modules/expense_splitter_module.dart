import 'package:flutter/material.dart';
import 'tool_module.dart';

// STEP 2 - Concrete Module: ExpenseSplitterModule
// This class extends ToolModule (Step 1).
//
// TODO (Steps 3-4): Replace buildBody() with a full StatefulWidget that has
//   private fields (_total, _pax, _tipPercent, _perPerson),
//   a compute() method, a reset() method, a Slider for tip, and all
//   required widgets including a ListView for the breakdown.

class ExpenseSplitterModule extends ToolModule {
  @override
  String get title => 'Expense Splitter';

  @override
  IconData get icon => Icons.receipt_long_outlined;

  // TODO: Replace this placeholder with your complete UI widget.
  @override
  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text(
        'Expense Splitter\n\nUI goes here - implement in Steps 3 & 4.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Color(0xFF007BFF)),
      ),
    );
  }
}
