import 'package:flutter/material.dart';
import 'package:the_book_nook/services/auth_services.dart';
import 'package:the_book_nook/widgets/auth_form.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterPressed;

  const LoginScreen({super.key, required this.onRegisterPressed});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

 Future<void> _login() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    print('🔐 Iniciando sesión con:');
    print('📧 Email: $email');
    print('🔒 Password: $password');

    final error = await AuthService.loginUser(
      email: email,
      password: password,
      context: context,
    );

    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Sesión iniciada correctamente')),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      print('❌ Error de login: $error');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthForm(
        title: 'Log In',
        actionText: 'Log In',
        errorMessage: _errorMessage,
        isLoading: _isLoading,
        emailController: _emailController,
        passwordController: _passwordController,
        onSubmit: _login,
        toggleAuthMode: widget.onRegisterPressed,
        isLoginMode: true,
      ),
    );
  }
}