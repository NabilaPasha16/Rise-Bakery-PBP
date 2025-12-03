class ContactMessage {
  final String name;
  final String email;
  final String message;
  final DateTime sentAt;

  ContactMessage({
    required this.name,
    required this.email,
    required this.message,
    DateTime? sentAt,
  }) : sentAt = sentAt ?? DateTime.now();

  /// Encapsulation using getters
  String get senderName => name;
  String get senderEmail => email;
  String get content => message;

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'message': message,
      'sentAt': sentAt.toIso8601String(),
    };
  }

  /// Polymorphism future usage for other contact types
  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      name: json['name'],
      email: json['email'],
      message: json['message'],
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
    );
  }
}
