import 'package:flutter/material.dart';
import 'modules/bmi_module.dart';
import 'modules/expense_splitter_module.dart';
import 'modules/grade_calculator_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const List<int> _presetColors = [0xFF007BFF, 0xFFBD1D2D, 0xFF9B59B6];

  String? _userName;
  int _themeIndex = 0;
  bool _useDarkMode = false;

  void _setUserName(String name) {
    final trimmed = name.trim();
    setState(() {
      if (trimmed.isEmpty) {
        _userName = null;
      } else {
        _userName = trimmed;
      }
    });
  }

  void _setThemeIndex(int i) {
    if (i < 0 || i >= _presetColors.length) return;
    setState(() {
      _themeIndex = i;
    });
  }

  void _setUseDarkMode(bool v) {
    setState(() {
      _useDarkMode = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seed = Color(_presetColors[_themeIndex]);
    final brightness = _useDarkMode ? Brightness.dark : Brightness.light;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
    );

    final theme = ThemeData.from(colorScheme: colorScheme, useMaterial3: true)
        .copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        );

    return MaterialApp(
      title: 'Daily Helper Toolkit',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: _userName == null
          ? OnboardingScreen(
              onSubmitName: _setUserName,
              onChooseTheme: _setThemeIndex,
              currentThemeIndex: _themeIndex,
              presetColors: _presetColors,
              onToggleDark: _setUseDarkMode,
              currentUseDark: _useDarkMode,
            )
          : HomeScreen(
              userName: _userName!,
              onChangeName: _setUserName,
              onChangeTheme: _setThemeIndex,
              presetColors: _presetColors,
              currentThemeIndex: _themeIndex,
              onToggleDark: _setUseDarkMode,
              currentUseDark: _useDarkMode,
            ),
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final modules = [
      BmiModule(userName: widget.userName, onPersonalize: _openSettingsDialog),
      ExpenseSplitterModule(
        userName: widget.userName,
        onPersonalize: _openSettingsDialog,
      ),
      GradeCalculatorModule(
        userName: widget.userName,
        onPersonalize: _openSettingsDialog,
      ),
    ];

    final current = modules[_selectedIndex];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: current.buildBody(context))],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: modules
            .map(
              (m) =>
                  BottomNavigationBarItem(icon: Icon(m.icon), label: m.title),
            )
            .toList(),
      ),
    );
  }

  void _openSettingsDialog() {
    final nameController = TextEditingController(text: widget.userName);
    int selected = widget.currentThemeIndex;
    bool useDark = widget.currentUseDark;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personalize'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark mode'),
                Switch(
                  value: useDark,
                  onChanged: (v) {
                    setState(() => useDark = v);
                    widget.onToggleDark(v);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(widget.presetColors.length, (i) {
                final color = Color(widget.presetColors[i]);
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selected = i);
                      widget.onChangeTheme(i);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: selected == i
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onChangeName(nameController.text);
              widget.onChangeTheme(selected);
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String userName;
  final void Function(String) onChangeName;
  final void Function(int) onChangeTheme;
  final List<int> presetColors;
  final int currentThemeIndex;
  final void Function(bool) onToggleDark;
  final bool currentUseDark;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.onChangeName,
    required this.onChangeTheme,
    required this.presetColors,
    required this.currentThemeIndex,
    required this.onToggleDark,
    required this.currentUseDark,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class OnboardingScreen extends StatefulWidget {
  final void Function(String) onSubmitName;
  final void Function(int) onChooseTheme;
  final int currentThemeIndex;
  final List<int> presetColors;
  final void Function(bool) onToggleDark;
  final bool currentUseDark;

  const OnboardingScreen({
    super.key,
    required this.onSubmitName,
    required this.onChooseTheme,
    required this.currentThemeIndex,
    required this.presetColors,
    required this.onToggleDark,
    required this.currentUseDark,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selected = 0;
  late bool _useDark;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentThemeIndex;
    _useDark = widget.currentUseDark;
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'What should we call you?',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _nameController,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Your display name',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Dark mode'),
                      const SizedBox(width: 8),
                      Switch(
                        value: _useDark,
                        onChanged: (v) {
                          setState(() => _useDark = v);
                          widget.onToggleDark(v);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Choose a theme color',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.presetColors.length, (i) {
                      final color = Color(widget.presetColors[i]);
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selected = i);
                          widget.onChooseTheme(i);
                        },
                        child: Container(
                          width: 80,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: _selected == i
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 16),
                  if (_nameController.text.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        'Hi, ${_nameController.text.trim()}!',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                  const SizedBox(height: 8),
                  SizedBox(
                    width: 320,
                    child: ElevatedButton(
                      onPressed: _nameController.text.trim().isEmpty
                          ? null
                          : () {
                              widget.onChooseTheme(_selected);
                              widget.onSubmitName(_nameController.text);
                            },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
