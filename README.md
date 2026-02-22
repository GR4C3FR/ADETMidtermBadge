# Midterm Skill-Based Badging (midterm_badge)

---

## Group #4 — Member List

- James Jethro Dizon  
- Charles Daniel Garcia  
- Ericka Mae Gavino  
- Carla Joves  
- Alexander Manabat  

---

## Assigned Roles & Tasks

- **Charles Daniel Garcia** — Project Lead, Step 1 & Step 2  
- **James Jethro Dizon** — Step 3 Implementation  
- **Ericka Mae Gavino** — Step 4 Implementation  
- **Alexander Manabat** — Step 5 Implementation & Documentation  
- **Carla Joves** — Step 6 Implementation & Documentation  

---

## Selected Modules

The application consists of the following modules:

- ✅ **BMI Checker** — Calculates Body Mass Index and displays health classification  
- ✅ **Expense Tracker** — Tracks and manages daily expenses  
- ✅ **Grade Calculator** — Computes academic grades based on user input  

---

## ✅ Features Checklist
## ✅ Feature Checklist (OOP + Flutter Implementation)

## ✅ Feature Checklist (OOP + Flutter Implementation)

| Step | Requirement | Achieved in App |
|------|------------|----------------|
| Step 1 - Abstraction | Create an abstract class that all mini-tools follow with title, icon, and buildBody structure. | ✅ Achieved — All modules implement a shared structure ensuring consistent navigation and UI contract. |
| | Abstract getters: title, icon | ✅ Implemented in all modules. |
| | Abstract method: buildBody(context) | ✅ Each module provides its own UI through buildBody. |
| Step 2 - Inheritance | Create 3 concrete modules implementing the abstract class. | ✅ Achieved — BMI Checker, Expense Tracker, Grade Calculator extend the shared module. |
| | Each module must present a complete UI | ✅ Achieved — All modules display independent UI screens with proper input, buttons, and output. |
| Step 3 - Encapsulation | Private state management in each module. | ✅ Achieved — Each module uses private variables for inputs and results. |
| | Controlled updates via methods (compute/reset/add) | ✅ Achieved — Modules update state internally; results cannot be edited directly from outside. |
| Step 4 - Widget Literacy | Use minimum required widgets: Scaffold, AppBar, Text, Icon, Container/Card, TextField, Button, ListView, SnackBar/Dialog, Navigation. | ✅ Achieved — All modules include appropriate widgets across screens. |
| | Use Slider or Dropdown for configurable values | ✅ Achieved — Slider or Dropdown is used for tip %, grading, or other module-specific settings. |
| Step 5 - Polymorphism | Use a polymorphic collection of modules to generate navigation items and display screens dynamically. | ✅ Achieved — All modules stored in a list and navigated via BottomNavigationBar. |
| Step 6 - Dynamic Invocation | Display module title, icon, and UI dynamically when switching tabs. | ✅ Achieved — Navigation correctly updates UI based on selected module. |

## 🚀 How to Run the Project

```cmd
:: 1. Clone the repository
git clone https://github.com/GR4C3FR/MiniJiraBoard.git

:: 2. Navigate to project folder
cd MiniJiraBoard

:: 3. Check Flutter setup and fix errors if needed
flutter doctor

:: 4. Install project dependencies
flutter pub get

:: 5. Run the application
flutter run

:: 6. Select a device (Chrome, Windows, Android Emulator, Edge, etc.)
