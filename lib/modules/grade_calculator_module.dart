import 'package:flutter/material.dart';
import 'tool_module.dart';

class GradeCalculatorModule extends ToolModule {
  @override
  String get title => 'Grade Calculator';

  @override
  IconData get icon => Icons.school_outlined;

  final String userName;
  final VoidCallback? onPersonalize;

  GradeCalculatorModule({required this.userName, this.onPersonalize});

  @override
  Widget buildBody(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(children: [Icon(icon), const SizedBox(width: 8), Text(title)]),
      actions: [
        IconButton(
          onPressed: onPersonalize,
          tooltip: 'Personalize',
          icon: const Icon(Icons.palette),
        ),
      ],
    ),
    body: _GradeScreen(userName: userName),
  );
}

class _GradeComponent {
  final String name;
  final double score;
  final double weight;

  const _GradeComponent({
    required this.name,
    required this.score,
    required this.weight,
  });

  double get contribution => score * (weight / 100);
}

class _GradeScreen extends StatefulWidget {
  final String userName;
  const _GradeScreen({required this.userName});

  @override
  State<_GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<_GradeScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _scoreCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  final List<_GradeComponent> _components = [];

  double? _finalGrade;

  void _addComponent() {
    final String name = _nameCtrl.text.trim();
    final double? score = double.tryParse(_scoreCtrl.text);
    final double? weight = double.tryParse(_weightCtrl.text);

    if (name.isEmpty || score == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill in all fields before adding.')),
      );
      return;
    }
    if (score < 0 || score > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Score must be between 0 and 100.')),
      );
      return;
    }
    if (weight <= 0 || weight > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight must be between 1 and 100.')),
      );
      return;
    }

    setState(() {
      _components.add(
        _GradeComponent(name: name, score: score, weight: weight),
      );
      _finalGrade = null;
    });

    _nameCtrl.clear();
    _scoreCtrl.clear();
    _weightCtrl.clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('"$name" added.')));
  }

  void _removeComponent(int index) {
    setState(() {
      _components.removeAt(index);
      _finalGrade = null;
    });
  }

  void _compute() {
    if (_components.isEmpty) {
      _showErrorDialog(
        'No Components Added',
        'Please add at least one grade component before computing.',
      );
      return;
    }

    final double totalWeight = _components.fold(0, (sum, c) => sum + c.weight);
    if ((totalWeight - 100).abs() > 0.01) {
      _showErrorDialog(
        'Weight Mismatch',
        'Your component weights add up to ${totalWeight.toStringAsFixed(1)}%.\n'
            'They should total exactly 100%.\n\n'
            'Please adjust your weights and try again.',
      );
      return;
    }

    final double grade = _components.fold(0, (sum, c) => sum + c.contribution);

    setState(() => _finalGrade = grade);
  }

  void _reset() {
    setState(() {
      _components.clear();
      _finalGrade = null;
    });
    _nameCtrl.clear();
    _scoreCtrl.clear();
    _weightCtrl.clear();
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _gradeRemarks(double grade) {
    if (grade >= 90) return 'Excellent (A)';
    if (grade >= 80) return 'Good (B)';
    if (grade >= 70) return 'Average (C)';
    if (grade >= 60) return 'Passing (D)';
    return 'Failing (F)';
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
            'Add each grade component (e.g. Quizzes, Midterm, Finals).\n'
            'Make sure all weights add up to 100%.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add a Grade Component',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Component name (e.g. Quizzes)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _scoreCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Score (0–100)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _weightCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Weight (%)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: _addComponent,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Component'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (_components.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Components',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Total weight: ${_components.fold(0.0, (s, c) => s + c.weight).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color:
                        (_components.fold(0.0, (s, c) => s + c.weight) - 100)
                                .abs() <
                            0.01
                        ? Colors.green
                        : Colors.orange,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _components.length,
              itemBuilder: (context, index) {
                final c = _components[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(c.name),
                    subtitle: Text(
                      'Score: ${c.score}  |  Weight: ${c.weight}%  |  Contribution: ${c.contribution.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: 'Remove',
                      onPressed: () => _removeComponent(index),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _compute,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Compute Grade'),
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

          if (_finalGrade != null)
            Card(
              elevation: 3,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.emoji_events_outlined, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      'Final Grade: ${_finalGrade!.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _gradeRemarks(_finalGrade!),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
