import 'cake_category.dart';

// Encapsulation: gunakan private field dan public getter/setter
class Cake {
  String name;
  double price;
  String imagePath;
  String description;
  CakeCategory? category;

  Cake(this.name, this.price, this.imagePath, {this.description = "", this.category});

  // Polymorphism: method yang bisa di-override
  String getCakeInfo() {
    final cat = category != null ? ' (${category!.name})' : '';
    return '$name$cat - Rp${price.toStringAsFixed(0)}';
  }
}

// Inheritance: SpecialCake mewarisi Cake
class SpecialCake extends Cake {
  String specialFeature;

  SpecialCake(String name, double price, String imagePath, this.specialFeature,
      {String description = "", CakeCategory? category})
      : super(name, price, imagePath, description: description, category: category);

  // Polymorphism: override method
  @override
  String getCakeInfo() => '$name (Spesial: $specialFeature) - Rp${price.toStringAsFixed(0)}';
}
