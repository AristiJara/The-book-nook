import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> recommendedBooks = const [
    "Book A",
    "Book B",
    "Book C",
    "Book D",
    "Book E",
  ];

  final List<String> otherBooks = const [
    "Book 1",
    "Book 2",
    "Book 3",
    "Book 4",
    "Book 5",
    "Book 6",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF37474F),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'The Book Nook',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Recommended',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedBooks.length,
                itemBuilder: (context, index) {
                  final book = recommendedBooks[index];
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 10),
                    color: Colors.blueGrey[100],
                    child: Center(child: Text(book)),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Books',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: otherBooks.length,
                itemBuilder: (context, index) {
                  final book = otherBooks[index];
                  return Container(
                    height: 300,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    color: Colors.blueGrey[50],
                    child: Text(book),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
