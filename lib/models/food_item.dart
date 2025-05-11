class FoodItem {
  final String foodName;
  final int calories;
  final String imageUrl;
  final int price;
  int quantity;

  FoodItem({
    required this.foodName,
    required this.calories,
    required this.imageUrl,
    required this.price,
    this.quantity = 0,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      foodName: json['food_name'] as String,
      calories: json['calories'] as int,
      imageUrl: json['image_url'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_name': foodName,
      'calories': calories,
      'image_url': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  FoodItem copyWith({int? quantity}) {
    return FoodItem(
      foodName: foodName,
      calories: calories,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }
} 