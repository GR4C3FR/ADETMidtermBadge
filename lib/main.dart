import 'package:flutter/material.dart';
import 'modules/bmi_module.dart';
import 'modules/expense_splitter_module.dart';
import 'modules/grade_calculator_module.dart';
import 'modules/tool_module.dart';

void main() {
  runApp(const MyApp());
}

// MyApp is the root of the whole application.
// It sets up the theme and tells Flutter which screen to show first.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Helper Toolkit',
      debugShowCheckedModeBanner: false,
      // Material 3 theme with a blue seed color
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF007BFF),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HomeScreen — the main screen that holds all 3 modules in a BottomNavigationBar
// ─────────────────────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Which tab is currently shown (0 = BMI, 1 = Expense, 2 = Grade)
  int _selectedIndex = 0;

  // List of all our tool modules
  final List<ToolModule> _modules = [
    BmiModule(),
    ExpenseSplitterModule(),
    GradeCalculatorModule(),
  ];

  @override
  Widget build(BuildContext context) {
    final ToolModule current = _modules[_selectedIndex];

    return Scaffold(
      // AppBar shows the icon + title of the active module
      appBar: AppBar(
        title: Row(
          children: [
            Icon(current.icon), // Icon from the active module
            const SizedBox(width: 8),
            Text(current.title), // Title from the active module
          ],
        ),
      ),

      // Body is the UI of the currently selected module
      body: current.buildBody(context),

      // BottomNavigationBar lets the user switch between the 3 tools
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          // Update the selected tab when the user taps a bottom icon
          setState(() => _selectedIndex = index);
        },
        items: _modules
            .map(
              (m) => BottomNavigationBarItem(
                icon: Icon(m.icon),
                label: m.title,
              ),
            )
            .toList(),
      ),
    );
  }
}
