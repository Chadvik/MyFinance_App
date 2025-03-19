# MyFinance - Personal Finance Tracker

![Flutter](https://img.shields.io/badge/Flutter-3.19.3-blue) ![Dart](https://img.shields.io/badge/Dart-3.3.1-blue) ![License](https://img.shields.io/badge/License-MIT-green)

**MyFinance** is a Flutter-based mobile application designed to help users manage their personal finances. It allows tracking income and expenses, categorizing transactions, and visualizing spending through a pie chart. The app features a clean, teal-themed UI, unit and widget tests for reliability, and is built with a modular architecture using the Provider package for state management.

---

## Features
- **Transaction Management**: Add, edit, and delete income and expense transactions.
- **Category Tracking**: Organize transactions by categories (e.g., Work, Food).
- **Monthly Summary**: View total income, expenses, and net balance for the current month.
- **Spending Visualization**: Interactive pie chart showing spending by category with subtle, eye-friendly colors.
- **Testing**: Includes unit tests for `FinanceProvider` and widget tests for `TransactionListScreen`.

---

## Prerequisites
Before running the project, ensure you have the following installed:

1. **Flutter SDK**: Version 3.19.3 (stable)
   - [Install Flutter](https://flutter.dev/docs/get-started/install)
2. **Dart**: Version 3.3.1 (included with Flutter)
3. **Git**: For cloning the repository
   - [Install Git](https://git-scm.com/downloads)
4. **VS Code** (recommended) or another IDE:
   - Install the Flutter and Dart extensions for VS Code.
5. **Android Emulator / iOS Simulator** or a physical device:
   - Android Studio for Android emulator setup.
   - Xcode for iOS simulator (macOS only).
6. **Firebase** :
   - Set up a Firebase project and add the `google-services.json` (Android) or `GoogleService-Info.plist` (iOS) files.

---

## Getting Started

### 1. Clone the Repository
Clone the project from GitHub to your local machine:
```bash
git clone https://github.com/Chadvik/MyFinance_App.git
cd my_finance
