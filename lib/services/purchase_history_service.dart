import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/purchase_history.dart';

class PurchaseHistoryService {
  static const String _storageKey = 'purchase_history_list';

  // Simpan riwayat pembelian baru
  static Future<void> savePurchase(PurchaseHistory purchase) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Ambil riwayat yang sudah ada
      final historyJson = prefs.getStringList(_storageKey) ?? [];
      
      // Tambahkan riwayat baru di awal list (paling baru)
      historyJson.insert(0, jsonEncode(purchase.toJson()));
      
      // Simpan kembali ke SharedPreferences
      await prefs.setStringList(_storageKey, historyJson);
    } catch (e) {
      print('Error saving purchase history: $e');
    }
  }

  // Ambil semua riwayat pembelian
  static Future<List<PurchaseHistory>> getPurchaseHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_storageKey) ?? [];
      
      return historyJson
          .map((json) => PurchaseHistory.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading purchase history: $e');
      return [];
    }
  }

  // Hapus riwayat berdasarkan transaction ID
  static Future<void> deletePurchase(String transactionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_storageKey) ?? [];
      
      historyJson.removeWhere((json) {
        final data = jsonDecode(json);
        return data['transactionId'] == transactionId;
      });
      
      await prefs.setStringList(_storageKey, historyJson);
    } catch (e) {
      print('Error deleting purchase history: $e');
    }
  }

  // Hapus semua riwayat
  static Future<void> clearAllHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing purchase history: $e');
    }
  }
}
