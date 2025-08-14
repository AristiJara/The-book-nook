class Book {
  final String id;
  final String title;
  final String author;
  final double price;
  final String description;
  //final String image;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.description,
    //required this.image,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      //image: json['image'] ?? '',
    );
  }
}
