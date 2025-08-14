import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_book_nook/providers/user_provider.dart';
import 'package:the_book_nook/screens/book_screen.dart';
import 'package:the_book_nook/screens/cart_screen.dart';
import 'package:the_book_nook/screens/home_screen.dart';
import 'package:the_book_nook/screens/login_screen.dart';
import 'package:the_book_nook/screens/register_screen.dart';
import 'package:the_book_nook/screens/menu_screen.dart';
import 'package:the_book_nook/screens/account_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _accountScreenIndex = 0;

  void _showRegister() {
    setState(() {
      _accountScreenIndex = 1;
    });
  }

  void _showLogin() {
    setState(() {
      _accountScreenIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<UserProvider>(context).isAdmin();

    final userProvider = Provider.of<UserProvider>(context);
    final isLoggedIn = userProvider.user != null;

    final accountScreen = isLoggedIn
        ? const AccountScreen()
        : (_accountScreenIndex == 0
            ? LoginScreen(onRegisterPressed: _showRegister)
            : RegisterScreen(onLoginPressed: _showLogin));

    final List<Widget> screens = [
      const HomeScreen(),        // 0
      const CartScreen(),        // 1
      if (isAdmin) BookScreen(token: userProvider.user!.token),
      accountScreen,             // 2 o 3
      const MenuScreen(),        // 3 o 4
    ];

    final List<Widget> navIcons = [
      _buildNavIcon(Icons.home, 0),
      _buildNavIcon(Icons.shopping_cart, 1),
      if (isAdmin) _buildNavIcon(Icons.add, 2),
      _buildNavIcon(Icons.person, isAdmin ? 3 : 2),
      _buildNavIcon(Icons.menu, isAdmin ? 4 : 3),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF37474F),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: navIcons,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          if (icon == Icons.person) _accountScreenIndex = 0;
        });
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white54,
          size: 24,
        ),
      ),
    );
  }
}