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
| Step | Concept | How It Was Achieved in the App |
|-----|--------|--------------------------------|
| **Step 1** | Abstraction | A shared module contract ensures all tools follow the same structure for title, icon, and UI body, allowing consistent navigation and scalability. |
| **Step 2** | Inheritance | BMI Checker, Expense Tracker, and Grade Calculator extend the shared module structure, enabling independent logic while keeping uniform behavior across modules. |
| **Step 3** | Encapsulation | Each module manages private state such as inputs and computed results, with controlled updates through internal computation and reset methods to prevent external modification. |
| **Step 4** | Widget Literacy | The app demonstrates proper Flutter widget usage including layout scaffolding, input handling, feedback mechanisms, list displays, and multi-page navigation using bottom navigation. |
| **Step 5** | Polymorphism | All modules are stored in a single collection used to dynamically generate navigation items and switch screens, enabling flexible expansion without modifying core navigation logic. |

---

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
