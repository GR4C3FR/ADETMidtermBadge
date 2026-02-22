import 'package:flutter/material.dart';
import 'tool_module.dart';

class ExpenseSplitterModule extends ToolModule {
  @override
  String get title => 'Expense Splitter';

  @override
  IconData get icon => Icons.receipt_long_outlined;

  final String userName;

  ExpenseSplitterModule({required this.userName});

  @override
  Widget buildBody(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(children: [Icon(icon), const SizedBox(width: 8), Text(title)]),
    ),
    body: _ExpenseScreen(userName: userName),
  );
}

class _ExpenseScreen extends StatefulWidget {
  final String userName;
  const _ExpenseScreen({required this.userName});

  @override
  State<_ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<_ExpenseScreen> {
  final TextEditingController _totalCtrl = TextEditingController();
  final TextEditingController _paxCtrl = TextEditingController();

  double _tipPercent = 0;

  double? _tipAmount;
  double? _grandTotal;
  double? _perPerson;

  void _compute() {
    double? total = double.tryParse(_totalCtrl.text);
    int? pax = int.tryParse(_paxCtrl.text);

    if (total == null || pax == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers.')),
      );
      return;
    }
    if (total <= 0 || pax <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bill amount and people count must be above 0.'),
        ),
      );
      return;
    }

    setState(() {
      _tipAmount = total * (_tipPercent / 100);
      _grandTotal = total + _tipAmount!;
      _perPerson = _grandTotal! / pax;
    });
  }

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
    final List<Map<String, String>> breakdown = _perPerson == null
        ? []
        : [
            {
              'label': 'Bill amount',
              'value': '₱${double.parse(_totalCtrl.text).toStringAsFixed(2)}',
            },
            {
              'label': 'Tip (${_tipPercent.toStringAsFixed(0)}%)',
              'value': '₱${_tipAmount!.toStringAsFixed(2)}',
            },
            {
              'label': 'Grand total',
              'value': '₱${_grandTotal!.toStringAsFixed(2)}',
            },
            {'label': 'Number of people', 'value': _paxCtrl.text},
            {
              'label': 'Each person pays',
              'value': '₱${_perPerson!.toStringAsFixed(2)}',
            },
          ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Hi, ${widget.userName}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Text(
            'Enter the total bill and number of people to split it.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

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
                  label: '${_tipPercent.toStringAsFixed(0)}%',
                  onChanged: (v) => setState(() => _tipPercent = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

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
