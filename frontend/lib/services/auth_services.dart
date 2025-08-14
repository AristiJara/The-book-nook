import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_book_nook/providers/user_provider.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.20:3000'; // 192.168.0.20 o localhost 10.0.2.2

  static Future<String?> registerUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': 'user',
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return data['message'] ?? 'Account created successfully';
      } else {
        return data['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      return 'Error al conectar con el servidor';
    }
  }

static Future<String?> loginUser({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  final url = Uri.parse('$baseUrl/auth/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final role = data['user']['role'] ?? 'user';

      final userData = data['user'];

      Provider.of<UserProvider>(context, listen: false).setUser(
        email: email,
        token: token,
        role: role,
        username: userData['username'],
        birthday: userData['birthday'],
        phone: userData['phone_number'],
        theme: userData['theme'],
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('token', token);
      await prefs.setString('role', role);
      if (userData['username'] != null) await prefs.setString('username', userData['username']);
      if (userData['birthday'] != null) await prefs.setString('birthday', userData['birthday']);
      if (userData['phone_number'] != null) await prefs.setString('phone', userData['phone_number']);
      if (userData['theme'] != null) await prefs.setString('theme', userData['theme']);

      return null;
    } else {
      final body = jsonDecode(response.body);
      return body['message'] ?? 'Credenciales incorrectas';
    }
  } catch (e) {
    print('Error: $e');
    return 'Error al conectar con el servidor';
  }
}


  static Future<String> logout(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String message = '';

    try {
      final token = userProvider.user?.token;
      if (token != null) {
        final url = Uri.parse('$baseUrl/auth/logout');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          message = data['message'] ?? message;
        } else {
          message = 'Error al cerrar sesión';
        }
      }
    } catch (e) {
      message = 'Error de conexión: $e';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    userProvider.clearUser();
    return message;
  }

  static Future<Map<String, dynamic>?> fetchUserProfile(String token) async {
    final url = Uri.parse('$baseUrl/me');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['user']; 
      } else {
        debugPrint('Error al obtener perfil: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Excepción en fetchUserProfile: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String token,
    String? username,
    String? birthday,
    String? phoneNumber,
  }) async {
    final url = Uri.parse('$baseUrl/user/profile');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        if (username != null) 'username': username,
        if (birthday != null) 'birthday': birthday,
        if (phoneNumber  != null) 'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user']; // El backend debe devolver el usuario actualizado
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
}