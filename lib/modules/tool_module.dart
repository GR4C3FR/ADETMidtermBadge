import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ABSTRACT CLASS — ToolModule
// ─────────────────────────────────────────────────────────────────────────────
// This is the "contract" or "blueprint" that every mini-tool MUST follow.
// Think of it like a Shape class: every shape must have a calculateArea().
// Here, every tool module must have a title, an icon, and a buildBody().
//
// abstract = you cannot create a ToolModule directly.
//            You must create a concrete class (like BmiModule) that extends it.
// ─────────────────────────────────────────────────────────────────────────────

abstract class ToolModule {
  // Every tool must provide a title (shown in the tab bar).
  String get title;

  // Every tool must provide an icon (shown in the tab bar).
  IconData get icon;

  // Every tool must build its own UI widget when called.
  Widget buildBody(BuildContext context);
}
