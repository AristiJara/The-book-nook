import 'package:flutter/material.dart';
import 'package:the_book_nook/services/auth_services.dart';
import 'package:the_book_nook/widgets/auth_form.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginPressed;

  const RegisterScreen({super.key, required this.onLoginPressed});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final message = await AuthService.registerUser(
      email: _emailController.text,
      password: _passwordController.text,
      context: context,
    );

    setState(() {
      _isLoading = false;
    });

    if (message == 'Account created successfully') {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message!)),
      );
      await AuthService.logout(context); 
      widget.onLoginPressed();
    } else {
      setState(() {
        _errorMessage = message;
      });
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
        title: 'Sign Up',
        actionText: 'Create Account',
        errorMessage: _errorMessage,
        isLoading: _isLoading,
        emailController: _emailController,
        passwordController: _passwordController,
        onSubmit: _register,
        toggleAuthMode: widget.onLoginPressed,
        isLoginMode: false,
      ),
    );
  }
}