import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_book_nook/providers/book_provider.dart';

class BookScreen extends StatefulWidget {
  final String token;

  const BookScreen({super.key, required this.token});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  bool _isLoading = false; 

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Libros"),
      ),
      body: bookProvider.books.isEmpty
          ? const Center(child: Text("No hay libros agregados"))
          : ListView.builder(
              itemCount: bookProvider.books.length,
              itemBuilder: (context, index) {
                final book = bookProvider.books[index];
                return ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(book.title),
                  subtitle: Text("${book.author} - \$${book.price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      try {
                        await bookProvider.deleteBook(book.id, widget.token);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Libro eliminado")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $e")),
                        );
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBookDialog(context, bookProvider, widget.token);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBookDialog(BuildContext context, BookProvider provider, String token) {
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Libro"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Título"),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: "Autor"),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: "Precio"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Descripción"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await provider.addBook(
                    title: titleController.text,
                    author: authorController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    description: descriptionController.text,
                    token: token,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Libro agregado")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                }
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }
}
