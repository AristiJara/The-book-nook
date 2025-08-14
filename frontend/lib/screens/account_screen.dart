import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_book_nook/providers/user_provider.dart';
import 'package:the_book_nook/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isEditing = false;

  late TextEditingController _usernameController;
  late TextEditingController _birthdayController;
  late TextEditingController _phoneController;

  String? originalUsername;
  String? originalBirthday;
  String? originalPhone;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user!;
    originalUsername = user.username ?? '';
    originalBirthday = user.birthday ?? '';
    originalPhone = user.phone ?? '';

    _usernameController = TextEditingController(text: originalUsername);
    _birthdayController = TextEditingController(text: originalBirthday);
    _phoneController = TextEditingController(text: originalPhone);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate;
    try {
      if (_birthdayController.text.isNotEmpty) {
        initialDate = DateTime.parse(_birthdayController.text);
      } else {
        initialDate = DateTime(2000);
      }
    } catch (_) {
      initialDate = DateTime(2000);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blueGrey.shade700,
            onPrimary: Colors.white,
            onSurface: Colors.blueGrey.shade900,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey.shade700,
            ),
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted = picked.toIso8601String().split('T')[0];
      setState(() {
        _birthdayController.text = formatted;
      });
    }
  }

  void _logout(BuildContext context) async {
    final message = await AuthService.logout(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> _saveChanges(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user?.token;
    if (token == null) return;

    try {
      final updatedUserData = await AuthService.updateProfile(
        token: token,
        username: _usernameController.text,
        birthday: _birthdayController.text,
        phoneNumber: _phoneController.text,
      );

      userProvider.updateProfile(
        username: updatedUserData['username'],
        birthday: updatedUserData['birthday'],
        phone: updatedUserData['phone_number'],
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', updatedUserData['username'] ?? '');
      await prefs.setString('birthday', updatedUserData['birthday'] ?? '');
      await prefs.setString('phone', updatedUserData['phone_number'] ?? '');

      originalUsername = updatedUserData['username'];
      originalBirthday = updatedUserData['birthday'];
      originalPhone = updatedUserData['phone_number'];

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: isEditing,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: isEditing
              ? OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey.shade700),
                  borderRadius: BorderRadius.circular(8),
                )
              : InputBorder.none,
          suffixIcon:
              readOnly ? const Icon(Icons.calendar_today_outlined) : null,
          labelStyle: TextStyle(
            color: isEditing
                ? Colors.blueGrey.shade700
                : Colors.blueGrey.shade900.withOpacity(0.6),
          ),
        ),
        style: TextStyle(
          color: Colors.blueGrey.shade900,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueGrey.shade900,
              Colors.blueGrey.shade600,
              Colors.blueGrey.shade400,
              Colors.blueGrey.shade200,
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 0.6, 0.85, 1.0],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 80, color: Colors.blueGrey.shade700.withOpacity(0.6)),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _usernameController.text.isNotEmpty
                              ? _usernameController.text
                              : user.email,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 4,
                                color: Colors.black54,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 3,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 20,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: Colors.blueGrey.shade700, // fondo azul que tienes
                      child: Icon(
                        isEditing ? Icons.close : Icons.edit,
                        color: Colors.white,  // <-- aquí cambias el color del icono
                      ),
                      onPressed: () async {
                        if (isEditing) {
                          await _saveChanges(context);
                        } else {
                          setState(() {
                            isEditing = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                color: Colors.white.withOpacity(0.85),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField('Username', _usernameController),
                      _buildTextField(
                        'Cumpleaños',
                        _birthdayController,
                        readOnly: true,
                        onTap: () {
                          if (isEditing) _selectDate(context);
                        },
                      ),
                      _buildTextField('Teléfono', _phoneController),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () => _logout(context),
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade700,
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
