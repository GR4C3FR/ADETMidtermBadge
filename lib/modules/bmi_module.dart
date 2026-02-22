import 'package:flutter/material.dart';
import 'tool_module.dart';

class BmiModule extends ToolModule {
  @override
  String get title => 'BMI Checker';

  @override
  IconData get icon => Icons.monitor_weight_outlined;

  @override
  Widget buildBody(BuildContext context) => const _BmiScreen();
}

// ─────────────────────────────────────────────────────────────────────────────
// _BmiScreen — Full BMI calculator screen
//
// Widgets used:
//   TextField + TextEditingController  (height & weight inputs)
//   DropdownButton                     (choose height unit: cm or m)
//   ElevatedButton                     (Compute, Reset)
//   Card                               (result display)
//   Icon                               (status icon on result card)
//   ListView                           (history of past calculations)
//   SnackBar                           (error messages)
// ─────────────────────────────────────────────────────────────────────────────
class _BmiScreen extends StatefulWidget {
  const _BmiScreen();

  @override
  State<_BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<_BmiScreen> {
  // Controllers hold what the user types in each field
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  // DropdownButton value — user picks "cm" or "m"
  String _unit = 'cm';

  // Stores the most recent BMI result (null = not calculated yet)
  double? _bmiValue;
  String _bmiCategory = '';

  // History list — each entry is a short string like "22.5 — Normal"
  final List<String> _history = [];

  // ── Compute ──────────────────────────────────────────────────────────────
  void _compute() {
    double? h = double.tryParse(_heightCtrl.text);
    double? w = double.tryParse(_weightCtrl.text);

    // Validate inputs
    if (h == null || w == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers.')),
      );
      return;
    }
    if (h <= 0 || w <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Height and weight must be above 0.')),
      );
      return;
    }

    // Convert height to metres for the BMI formula: weight / height^2
    final double heightInMetres = _unit == 'cm' ? h / 100 : h;
    final double bmi = w / (heightInMetres * heightInMetres);

    // Determine category based on standard BMI ranges
    String category;
    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal weight';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    setState(() {
      _bmiValue = bmi;
      _bmiCategory = category;
      // Add to history, newest entry at the top
      _history.insert(0, '${bmi.toStringAsFixed(1)} — $category');
    });
  }

  // ── Reset ─────────────────────────────────────────────────────────────────
  void _reset() {
    setState(() {
      _heightCtrl.clear();
      _weightCtrl.clear();
      _bmiValue = null;
      _bmiCategory = '';
      _history.clear();
    });
  }

  // ── Helper: pick an icon based on BMI category ────────────────────────────
  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Underweight':
        return Icons.arrow_downward;
      case 'Normal weight':
        return Icons.check_circle_outline;
      case 'Overweight':
        return Icons.arrow_upward;
      default:
        return Icons.warning_amber_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Instruction text ──────────────────────────────────────────────
          const Text(
            'Enter your height and weight to check your BMI.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // ── Height unit selector (DropdownButton) ─────────────────────────
          Row(
            children: [
              const Text('Height unit: '),
              const SizedBox(width: 8),
              // DropdownButton — lets the user choose between cm and m
              DropdownButton<String>(
                value: _unit,
                items: const [
                  DropdownMenuItem(value: 'cm', child: Text('Centimetres (cm)')),
                  DropdownMenuItem(value: 'm', child: Text('Metres (m)')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _unit = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Height input ──────────────────────────────────────────────────
          TextField(
            controller: _heightCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Height ($_unit)',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.height),
            ),
          ),
          const SizedBox(height: 12),

          // ── Weight input ──────────────────────────────────────────────────
          TextField(
            controller: _weightCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.fitness_center),
            ),
          ),
          const SizedBox(height: 16),

          // ── Action buttons ────────────────────────────────────────────────
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

          // ── Result Card — only shown after a successful calculation ────────
          if (_bmiValue != null)
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(
                  _categoryIcon(_bmiCategory),
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'BMI: ${_bmiValue!.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Category: $_bmiCategory'),
              ),
            ),

          // ── History section — ListView of past results ─────────────────────
          if (_history.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Calculation History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            // shrinkWrap + NeverScrollableScrollPhysics so it fits inside
            // SingleChildScrollView without conflicting scroll directions
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(_history[index]),
                    trailing: Text(
                      '#${_history.length - index}',
                      style: const TextStyle(color: Colors.grey),
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
