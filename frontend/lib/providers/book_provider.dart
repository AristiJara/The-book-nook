import 'package:flutter/material.dart';
import 'package:the_book_nook/models/book.dart';
import 'package:the_book_nook/services/book_services.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> addBook({
    required String title,
    required String author,
    required double price,
    required String description,
    required String token,
  }) async {
    final newBook = await BookService.addBook(
      title: title,
      author: author,
      price: price,
      description: description,
      token: token,
    );
    _books.add(newBook);
    notifyListeners();
  }

  Future<void> deleteBook(String id, String token) async {
    await BookService.deleteBook(id, token);
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }
}