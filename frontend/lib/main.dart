import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_book_nook/providers/book_provider.dart';
import 'package:the_book_nook/providers/user_provider.dart';
import 'package:the_book_nook/screens/login_screen.dart';
import 'package:the_book_nook/screens/main_screen.dart';
import 'package:the_book_nook/screens/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('token');
  final email = prefs.getString('email');
  final role = prefs.getString('role');
  final username = prefs.getString('username');
  final birthday = prefs.getString('birthday');
  final phone = prefs.getString('phone');
  final theme = prefs.getString('theme');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final provider = UserProvider();
            if (token != null && email != null && role != null) {
              provider.setUser(
                email: email,
                token: token,
                role: role,
                username: username,
                birthday: birthday,
                phone: phone,
                theme: theme,
              );
            }
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => BookProvider(), 
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF37474F),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF37474F),
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF37474F),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
      home: const MainScreen(),
      routes: {
        '/login': (context) => LoginScreen(
              onRegisterPressed: () {
                Navigator.of(context).pushReplacementNamed('/register');
              },
            ),
        '/register': (context) => RegisterScreen(
              onLoginPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
        '/home': (context) => const MainScreen(),
      },
    );
  }
}