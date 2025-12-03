import 'cake.dart';

class PurchaseHistory {
  final String transactionId;
  final List<Cake> items;
  final double totalPrice;
  final DateTime purchaseDate;
  final String paymentMethod;
  final String status; // "Berhasil", "Menunggu", etc

  PurchaseHistory({
    required this.transactionId,
    required this.items,
    required this.totalPrice,
    required this.purchaseDate,
    required this.paymentMethod,
    this.status = 'Berhasil',
  });

  // Konversi ke JSON untuk menyimpan ke SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'items': items.map((cake) {
        return {
          'name': cake.name,
          'price': cake.price,
          'imagePath': cake.imagePath,
          'description': cake.description,
        };
      }).toList(),
      'totalPrice': totalPrice,
      'purchaseDate': purchaseDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }

  // Parse dari JSON
  factory PurchaseHistory.fromJson(Map<String, dynamic> json) {
    return PurchaseHistory(
      transactionId: json['transactionId'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => Cake(
                    item['name'] ?? '',
                    item['price']?.toDouble() ?? 0.0,
                    item['imagePath'] ?? '',
                    description: item['description'] ?? '',
                  ))
              .toList() ??
          [],
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate'] ?? DateTime.now().toIso8601String()),
      paymentMethod: json['paymentMethod'] ?? 'Transfer Bank',
      status: json['status'] ?? 'Berhasil',
    );
  }
}
