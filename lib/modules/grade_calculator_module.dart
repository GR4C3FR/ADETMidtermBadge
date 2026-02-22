import 'package:flutter/material.dart';
import 'tool_module.dart';

class GradeCalculatorModule extends ToolModule {
  @override
  String get title => 'Grade Calculator';

  @override
  IconData get icon => Icons.school_outlined;

  @override
  Widget buildBody(BuildContext context) => const _GradeScreen();
}

// ─────────────────────────────────────────────────────────────────────────────
// _GradeComponent — a simple data class to hold one grade entry
// ─────────────────────────────────────────────────────────────────────────────
class _GradeComponent {
  final String name;   // e.g. "Quizzes"
  final double score;  // 0 – 100
  final double weight; // percentage, e.g. 30 means 30%

  const _GradeComponent({
    required this.name,
    required this.score,
    required this.weight,
  });

  // Weighted contribution of this component
  double get contribution => score * (weight / 100);
}

// ─────────────────────────────────────────────────────────────────────────────
// _GradeScreen — Multi-component weighted grade calculator
//
// Widgets used:
//   TextField + TextEditingController  (component name, score, weight)
//   ElevatedButton                     (Add Component, Compute, Reset)
//   Card                               (each component row + final result)
//   Icon                               (delete button per row)
//   ListView                           (list of added components)
//   Dialog                             (error messages & grade result)
//   SnackBar                           (quick confirmations)
// ─────────────────────────────────────────────────────────────────────────────
class _GradeScreen extends StatefulWidget {
  const _GradeScreen();

  @override
  State<_GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<_GradeScreen> {
  // Input controllers for the "add component" form
  final TextEditingController _nameCtrl   = TextEditingController();
  final TextEditingController _scoreCtrl  = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();

  // List of grade components the user has added
  final List<_GradeComponent> _components = [];

  // Final computed grade (null before computing)
  double? _finalGrade;

  // ── Add a Component ────────────────────────────────────────────────────────
  void _addComponent() {
    final String name = _nameCtrl.text.trim();
    final double? score  = double.tryParse(_scoreCtrl.text);
    final double? weight = double.tryParse(_weightCtrl.text);

    // Validate all fields
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
      _components.add(_GradeComponent(
        name: name,
        score: score,
        weight: weight,
      ));
      _finalGrade = null; // clear old result when list changes
    });

    // Clear the form fields after adding
    _nameCtrl.clear();
    _scoreCtrl.clear();
    _weightCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"$name" added.')),
    );
  }

  // ── Remove a Component ─────────────────────────────────────────────────────
  void _removeComponent(int index) {
    setState(() {
      _components.removeAt(index);
      _finalGrade = null;
    });
  }

  // ── Compute Final Grade ────────────────────────────────────────────────────
  void _compute() {
    if (_components.isEmpty) {
      // Show a Dialog asking them to add components first
      _showErrorDialog('No Components Added',
          'Please add at least one grade component before computing.');
      return;
    }

    // Check total weight
    final double totalWeight =
        _components.fold(0, (sum, c) => sum + c.weight);
    if ((totalWeight - 100).abs() > 0.01) {
      // Weights don't add up to 100 — warn with a Dialog
      _showErrorDialog(
        'Weight Mismatch',
        'Your component weights add up to ${totalWeight.toStringAsFixed(1)}%.\n'
        'They should total exactly 100%.\n\n'
        'Please adjust your weights and try again.',
      );
      return;
    }

    // All good — calculate weighted sum
    final double grade =
        _components.fold(0, (sum, c) => sum + c.contribution);

    setState(() => _finalGrade = grade);
  }

  // ── Reset everything ───────────────────────────────────────────────────────
  void _reset() {
    setState(() {
      _components.clear();
      _finalGrade = null;
    });
    _nameCtrl.clear();
    _scoreCtrl.clear();
    _weightCtrl.clear();
  }

  // ── Helper: show an AlertDialog for errors ─────────────────────────────────
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          // Dismiss the dialog
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ── Helper: grade letter from numeric grade ────────────────────────────────
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
          // ── Instruction ────────────────────────────────────────────────────
          const Text(
            'Add each grade component (e.g. Quizzes, Midterm, Finals).\n'
            'Make sure all weights add up to 100%.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // ── "Add Component" form ───────────────────────────────────────────
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

                  // Component name
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Component name (e.g. Quizzes)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.label_outline),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Score and weight side by side
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

                  // Add button
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

          // ── Components ListView — shown only when list is not empty ─────────
          if (_components.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Components',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                // Show running total of weights
                Text(
                  'Total weight: ${_components.fold(0.0, (s, c) => s + c.weight).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: (_components.fold(0.0, (s, c) => s + c.weight) - 100).abs() < 0.01
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
                    // Delete button — removes this component from the list
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

          // ── Compute / Reset buttons ────────────────────────────────────────
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

          // ── Final Grade result card ────────────────────────────────────────
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

