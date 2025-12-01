// model/cake_category.dart
class CakeCategory {
  String _id;
  String _name;
  String _description;
  String _assetImage;

  CakeCategory(String id, String name, String description, String assetImage)
    : _id = id,
      _name = name,
      _description = description,
      _assetImage = assetImage;

  // Getters (encapsulation)
  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get assetImage => _assetImage;

  // Setters (encapsulation)
  set id(String value) => _id = value;
  set name(String value) => _name = value;
  set description(String value) => _description = value;
  set assetImage(String value) => _assetImage = value;

  // JSON helpers
  factory CakeCategory.fromJson(Map<String, dynamic> json) => CakeCategory(
    json['id']?.toString() ?? '',
    json['name']?.toString() ?? '',
    json['description']?.toString() ?? '',
    json['assetImage']?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name,
    'description': _description,
    'assetImage': _assetImage,
  };

  CakeCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? assetImage,
  }) {
    return CakeCategory(
      id ?? _id,
      name ?? _name,
      description ?? _description,
      assetImage ?? _assetImage,
    );
  }

  // Polymorphism: method yang bisa di-override
  String getCategoryInfo() => '$_name ($_description)';

  @override
  String toString() => 'CakeCategory(id: $_id, name: $_name)';
}

class SpecialCategory extends CakeCategory {
  String _specialNote;

  SpecialCategory(
    String id,
    String name,
    String description,
    String assetImage,
    String specialNote,
  ) : _specialNote = specialNote,
      super(id, name, description, assetImage);

  String get specialNote => _specialNote;
  set specialNote(String v) => _specialNote = v;

  @override
  String getCategoryInfo() => '${super.name} ($_specialNote)';

  @override
  String toString() =>
      'SpecialCategory(name: ${super.name}, note: $_specialNote)';
}
