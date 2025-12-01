import 'cake_category.dart';

// Encapsulation: gunakan private fields dan public getter/setter
class Cake {
  String _name;
  double _price;
  String _imagePath;
  String _description;
  CakeCategory? _category;

  Cake(
    String name,
    double price,
    String imagePath, {
    String description = "",
    CakeCategory? category,
  }) : _name = name,
       _price = price,
       _imagePath = imagePath,
       _description = description,
       _category = category;

  // Getters
  String get name => _name;
  double get price => _price;
  String get imagePath => _imagePath;
  String get description => _description;
  CakeCategory? get category => _category;

  // Setters
  set name(String v) => _name = v;
  set price(double v) => _price = v;
  set imagePath(String v) => _imagePath = v;
  set description(String v) => _description = v;
  set category(CakeCategory? v) => _category = v;

  // JSON helpers
  factory Cake.fromJson(Map<String, dynamic> json) => Cake(
    json['name']?.toString() ?? '',
    (json['price'] is num)
        ? (json['price'] as num).toDouble()
        : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
    json['imagePath']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    category: json['category'] != null
        ? CakeCategory.fromJson(Map<String, dynamic>.from(json['category']))
        : null,
  );

  Map<String, dynamic> toJson() => {
    'name': _name,
    'price': _price,
    'imagePath': _imagePath,
    'description': _description,
    'category': _category?.toJson(),
  };

  Cake copyWith({
    String? name,
    double? price,
    String? imagePath,
    String? description,
    CakeCategory? category,
  }) {
    return Cake(
      name ?? _name,
      price ?? _price,
      imagePath ?? _imagePath,
      description: description ?? _description,
      category: category ?? _category,
    );
  }

  // Polymorphism: method yang bisa di-override
  String getCakeInfo() {
    final cat = _category != null ? ' (${_category!.name})' : '';
    return '$_name$cat - Rp${_price.toStringAsFixed(0)}';
  }
}

// Inheritance: SpecialCake mewarisi Cake
class SpecialCake extends Cake {
  String _specialFeature;

  SpecialCake(
    String name,
    double price,
    String imagePath,
    String specialFeature, {
    String description = "",
    CakeCategory? category,
  }) : _specialFeature = specialFeature,
       super(
         name,
         price,
         imagePath,
         description: description,
         category: category,
       );

  String get specialFeature => _specialFeature;
  set specialFeature(String v) => _specialFeature = v;

  // Polymorphism: override method
  @override
  String getCakeInfo() =>
      '${super.name} (Spesial: $_specialFeature) - Rp${super.price.toStringAsFixed(0)}';
}
