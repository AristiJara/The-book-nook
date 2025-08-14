import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the_book_nook/models/book.dart';

class BookService {
  static const String baseUrl = 'http://192.168.0.20:3000';

  static Future<Book> addBook({
    required String title,
    required String author,
    required double price,
    required String description,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/book/create');
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'author': author,
        'price': price,
        'description': description,
      }),
    );

    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return Book.fromJson(data['book']);
    } else {
      throw Exception('Error adding book: ${res.body}');
    }
  }

  static Future<void> deleteBook(String id, String token) async {
    final url = Uri.parse('$baseUrl/book/$id');
    final res = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Error deleting book');
    }
  }

  static Future<List<Book>> getBooks() async {
    final url = Uri.parse('$baseUrl/book');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final List<dynamic> data = jsonDecode(res.body);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching books: ${res.body}');
    }
  }
}
