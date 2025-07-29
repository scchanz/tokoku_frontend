class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int? stock;
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.stock,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price']),
      stock: json['stock'],
      imageUrl: json['image_url'],
    );
  }
}
