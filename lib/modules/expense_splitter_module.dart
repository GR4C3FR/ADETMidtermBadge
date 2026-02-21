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
  Widget buildBody(BuildContext context) => const _ExpenseSplitterStudent();
}

class _ExpenseSplitterStudent extends StatefulWidget {
  const _ExpenseSplitterStudent();
  @override
  State<_ExpenseSplitterStudent> createState() => _ExpenseSplitterStudentState();
}

class _ExpenseSplitterStudentState extends State<_ExpenseSplitterStudent> {
  final TextEditingController _total = TextEditingController();
  final TextEditingController _pax = TextEditingController();
  double _tipPercent = 0;
  double _perPerson = 0;

  void compute() {
    double? total = double.tryParse(_total.text);
    int? pax = int.tryParse(_pax.text);

    if (total == null || pax == null || pax <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid numbers 😅")),
      );
      return;
    }

    setState(() {
      _perPerson = (total + total * (_tipPercent / 100)) / pax;
    });
  }

  void reset() {
    setState(() {
      _total.text = "";
      _pax.text = "";
      _tipPercent = 0;
      _perPerson = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Enter total bill and number of people"),
          const SizedBox(height: 10),
          TextField(
            controller: _total,
            decoration: const InputDecoration(labelText: "Total amount"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pax,
            decoration: const InputDecoration(labelText: "Number of people"),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text("Tip %: "),
              Expanded(
                child: Slider(
                  value: _tipPercent,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  label: "${_tipPercent.toStringAsFixed(0)}%",
                  onChanged: (v) => setState(() => _tipPercent = v),
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(onPressed: compute, child: const Text("Compute")),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: reset, child: const Text("Reset")),
            ],
          ),
          const SizedBox(height: 16),
          Text("Each person pays: ${_perPerson.toStringAsFixed(2)}"),
        ],
      ),
    );
  }
}