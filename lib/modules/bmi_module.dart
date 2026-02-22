import 'package:flutter/material.dart';
import 'tool_module.dart';

class BmiModule extends ToolModule {
  @override
  String get title => 'BMI Checker';

  @override
  IconData get icon => Icons.monitor_weight_outlined;

  final String userName;

  BmiModule({required this.userName});

  @override
  Widget buildBody(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(children: [Icon(icon), const SizedBox(width: 8), Text(title)]),
    ),
    body: _BmiScreen(userName: userName),
  );
}

class _BmiScreen extends StatefulWidget {
  final String userName;
  const _BmiScreen({required this.userName});

  @override
  State<_BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<_BmiScreen> {
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  String _unit = 'cm';

  double? _bmiValue;
  String _bmiCategory = '';

  final List<String> _history = [];

  void _compute() {
    double? h = double.tryParse(_heightCtrl.text);
    double? w = double.tryParse(_weightCtrl.text);

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

    double heightInMetres;
    if (_unit == 'cm') {
      heightInMetres = h / 100;
    } else {
      heightInMetres = h;
    }
    final double bmi = w / (heightInMetres * heightInMetres);

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
      _history.insert(0, '${bmi.toStringAsFixed(1)} — $category');
    });
  }

  void _reset() {
    setState(() {
      _heightCtrl.clear();
      _weightCtrl.clear();
      _bmiValue = null;
      _bmiCategory = '';
      _history.clear();
    });
  }

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
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              'Hi, ${widget.userName}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const Text(
            'Enter your height and weight to check your BMI.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              const Text('Height unit: '),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _unit,
                items: const [
                  DropdownMenuItem(
                    value: 'cm',
                    child: Text('Centimetres (cm)'),
                  ),
                  DropdownMenuItem(value: 'm', child: Text('Metres (m)')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _unit = value);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),

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

          if (_history.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Calculation History',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
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
