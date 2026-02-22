import 'package:flutter/material.dart';
import 'tool_module.dart';

class ExpenseSplitterModule extends ToolModule {
  @override
  String get title => 'Expense Splitter';

  @override
  IconData get icon => Icons.receipt_long_outlined;

  @override
  Widget buildBody(BuildContext context) => const _ExpenseScreen();
}

// ─────────────────────────────────────────────────────────────────────────────
// _ExpenseScreen — Bill splitter with tip slider and itemised breakdown
//
// Widgets used:
//   TextField + TextEditingController  (total bill, number of people)
//   Slider                             (tip percentage 0–30%)
//   ElevatedButton                     (Compute, Reset)
//   Card                               (result summary card)
//   Icon                               (card decoration)
//   ListView                           (itemised breakdown list)
//   SnackBar                           (input validation errors)
// ─────────────────────────────────────────────────────────────────────────────
class _ExpenseScreen extends StatefulWidget {
  const _ExpenseScreen();

  @override
  State<_ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<_ExpenseScreen> {
  // Controllers for the two text inputs
  final TextEditingController _totalCtrl = TextEditingController();
  final TextEditingController _paxCtrl = TextEditingController();

  // Slider value for tip percentage (starts at 0%)
  double _tipPercent = 0;

  // Calculated values (null before any calculation)
  double? _tipAmount;
  double? _grandTotal;
  double? _perPerson;

  // ── Compute ────────────────────────────────────────────────────────────────
  void _compute() {
    double? total = double.tryParse(_totalCtrl.text);
    int? pax = int.tryParse(_paxCtrl.text);

    // Input validation
    if (total == null || pax == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers.')),
      );
      return;
    }
    if (total <= 0 || pax <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bill amount and people count must be above 0.')),
      );
      return;
    }

    setState(() {
      _tipAmount = total * (_tipPercent / 100);
      _grandTotal = total + _tipAmount!;
      _perPerson = _grandTotal! / pax;
    });
  }

  // ── Reset ──────────────────────────────────────────────────────────────────
  void _reset() {
    setState(() {
      _totalCtrl.clear();
      _paxCtrl.clear();
      _tipPercent = 0;
      _tipAmount = null;
      _grandTotal = null;
      _perPerson = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build breakdown rows only when results are available
    final List<Map<String, String>> breakdown = _perPerson == null
        ? []
        : [
            {'label': 'Bill amount', 'value': '₱${double.parse(_totalCtrl.text).toStringAsFixed(2)}'},
            {'label': 'Tip (${_tipPercent.toStringAsFixed(0)}%)', 'value': '₱${_tipAmount!.toStringAsFixed(2)}'},
            {'label': 'Grand total', 'value': '₱${_grandTotal!.toStringAsFixed(2)}'},
            {'label': 'Number of people', 'value': _paxCtrl.text},
            {'label': 'Each person pays', 'value': '₱${_perPerson!.toStringAsFixed(2)}'},
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Instruction ────────────────────────────────────────────────────
          const Text(
            'Enter the total bill and number of people to split it.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // ── Total bill input ───────────────────────────────────────────────
          TextField(
            controller: _totalCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Total bill (₱)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.payments_outlined),
            ),
          ),
          const SizedBox(height: 12),

          // ── Number of people input ─────────────────────────────────────────
          TextField(
            controller: _paxCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of people',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.group_outlined),
            ),
          ),
          const SizedBox(height: 16),

          // ── Tip percentage slider ──────────────────────────────────────────
          Row(
            children: [
              const Icon(Icons.percent, size: 20),
              const SizedBox(width: 6),
              Text('Tip: ${_tipPercent.toStringAsFixed(0)}%'),
              Expanded(
                child: Slider(
                  value: _tipPercent,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  // label shown in the bubble while dragging
                  label: '${_tipPercent.toStringAsFixed(0)}%',
                  onChanged: (v) => setState(() => _tipPercent = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Action buttons ─────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _compute,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Compute'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Result summary card ────────────────────────────────────────────
          if (_perPerson != null)
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 36,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Each person pays',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        Text(
                          '₱${_perPerson!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // ── Itemised breakdown ListView ────────────────────────────────────
          if (breakdown.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: breakdown.length,
              itemBuilder: (context, index) {
                final row = breakdown[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  child: ListTile(
                    title: Text(row['label']!),
                    trailing: Text(
                      row['value']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

