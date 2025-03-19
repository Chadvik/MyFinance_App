import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'screens/category_screen.dart';
import 'providers/finance_provider.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'themes/app_theme.dart'; // Import the theme

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init(); // Initialize notifications and timezone
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Track theme mode

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FinanceProvider()), // For reactive state
        Provider(create: (_) => AuthService()), // For non-reactive AuthService
      ],
      child: Builder(
        builder: (context) {
          // Access AuthService without Consumer
          final authService = Provider.of<AuthService>(context, listen: false);
          // Redirect to home if already signed in
          if (authService.currentUser != null && ModalRoute.of(context)?.settings.name == '/login') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/home');
            });
          }
          return MaterialApp(
            title: 'MyFinance',
            theme: AppTheme.lightTheme, // Default light theme
            darkTheme: AppTheme.darkTheme, // Dark theme option
            themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light, // Toggle between themes
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(),
              '/home': (context) => HomeScreen(),
              '/add_transaction': (context) => AddTransactionScreen(),
              '/transactions': (context) => TransactionListScreen(),
              '/categories': (context) => CategoryScreen(),
            },
            debugShowCheckedModeBanner: false, // Remove debug banner
          );
        },
      ),
    );
  }
}