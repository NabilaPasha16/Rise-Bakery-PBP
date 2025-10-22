// model/cake_category.dart
class CakeCategory {
  String id;
  String name;
  String description;
  String assetImage;

  CakeCategory({required this.id, required this.name, required this.description, required this.assetImage});

  // Polymorphism: method yang bisa di-override
  String getCategoryInfo() => '$name ($description)';
}

class SpecialCategory extends CakeCategory {
  String specialNote;

  SpecialCategory({required String id, required String name, required String description, required String assetImage, required this.specialNote}) : super(id: id, name: name, description: description, assetImage: assetImage);

  @override
  String getCategoryInfo() => '${super.name} ($specialNote)';
}
