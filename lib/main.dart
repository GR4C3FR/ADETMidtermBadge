import 'package:flutter/material.dart';

// TODO (Steps 3–6): Import and wire up your screens here.

// ─────────────────────────────────────────────────────────────────────────────
// Steps 1 & 2 are done — see tool_module.dart and the 3 module files.
// Steps 3–6 are your groupmates' responsibility.
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Daily Helper Toolkit',
      debugShowCheckedModeBanner: false,
      // TODO: Replace Placeholder with your HomeScreen (Steps 3–6)
      home: Scaffold(
        body: Center(
          child: Text(
            'Daily Helper Toolkit\n\nSteps 1 & 2 complete.\nConnect the UI in Steps 3–6.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Color(0xFF007BFF)),
          ),
        ),
      ),
    );
  }
}
