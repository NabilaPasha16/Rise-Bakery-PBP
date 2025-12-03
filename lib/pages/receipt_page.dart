import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/cake.dart';
import '../model/purchase_history.dart';
import '../utils/formatters.dart';
import '../services/purchase_history_service.dart';

class ReceiptPage extends StatefulWidget {
  final List<Cake> items;
  final double totalPrice;
  final String paymentMethod;

  const ReceiptPage({
    super.key,
    required this.items,
    required this.totalPrice,
    this.paymentMethod = 'Transfer Bank',
  });

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  late DateTime _transactionTime;
  late String _transactionId;

  @override
  void initState() {
    super.initState();
    _transactionTime = DateTime.now();
    _transactionId =
        'TRX-${_transactionTime.year}${_transactionTime.month.toString().padLeft(2, '0')}${_transactionTime.day.toString().padLeft(2, '0')}-${_transactionTime.hour.toString().padLeft(2, '0')}${_transactionTime.minute.toString().padLeft(2, '0')}${_transactionTime.second.toString().padLeft(2, '0')}';
    
    // ✅ Simpan riwayat pembelian otomatis
    _savePurchaseHistory();
  }

  // Fungsi untuk menyimpan riwayat pembelian
  void _savePurchaseHistory() {
    final purchase = PurchaseHistory(
      transactionId: _transactionId,
      items: widget.items,
      totalPrice: widget.totalPrice,
      purchaseDate: _transactionTime,
      paymentMethod: widget.paymentMethod,
      status: 'Berhasil',
    );
    
    PurchaseHistoryService.savePurchase(purchase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        title: Text(
          'Struk Pembayaran 🧾',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: textChocolate, // Warna Coklat
          ),
        ),
        backgroundColor: Colors.transparent, // Transparan
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: textChocolate), // Icon Coklat
        automaticallyImplyLeading: false, // Hilangkan tombol back default
      ),
      body: Container(
        // Background Gradient Theme
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgCream, bgPeach],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 HEADER TOKO
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: textChocolate.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '🍰 PILACAKE BAKERY 🍰',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: accentPink, // Warna Pink Tema
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toko Kue Premium Indonesia',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: textChocolate.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: bgPeach, // Garis pemisah peach
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 INFO TRANSAKSI
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: textChocolate.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReceiptRow('No. Transaksi', _transactionId, isBold: true),
                      const SizedBox(height: 12),
                      _buildReceiptRow(
                        'Waktu',
                        '${_transactionTime.day.toString().padLeft(2, '0')}/${_transactionTime.month.toString().padLeft(2, '0')}/${_transactionTime.year} ${_transactionTime.hour.toString().padLeft(2, '0')}:${_transactionTime.minute.toString().padLeft(2, '0')}',
                      ),
                      const SizedBox(height: 8),
                      _buildReceiptRow(
                        'Metode Pembayaran',
                        widget.paymentMethod,
                      ),
                      const SizedBox(height: 8),
                      _buildReceiptRow(
                        'Status',
                        'Berhasil ✓',
                        valueColor: Colors.green.shade700, // Hijau agak gelap agar terbaca
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 DAFTAR ITEM & RINGKASAN
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: textChocolate.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Pesanan',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textChocolate,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(height: 1, color: bgPeach),
                      const SizedBox(height: 12),
                      
                      // List Item Loop
                      ...List.generate(
                        widget.items.length,
                        (idx) {
                          final item = widget.items[idx];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: textChocolate,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'x1',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: textChocolate.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    formatRupiah(item.price),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: textChocolate,
                                    ),
                                  ),
                                ],
                              ),
                              if (idx < widget.items.length - 1)
                                Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    Divider(color: Colors.grey.shade100),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      Container(height: 2, color: bgPeach), // Garis tebal pemisah total
                      const SizedBox(height: 16),

                      // Ringkasan
                      _buildReceiptRow(
                        'Subtotal',
                        formatRupiah(widget.totalPrice),
                      ),
                      const SizedBox(height: 8),
                      _buildReceiptRow(
                        'Diskon',
                        formatRupiah(0),
                        valueColor: buttonGold, // Warna gold untuk diskon/promo
                      ),
                      const SizedBox(height: 8),
                      _buildReceiptRow(
                        'Ongkos Kirim',
                        'Gratis',
                        valueColor: Colors.green.shade700,
                      ),
                      const SizedBox(height: 16),
                      _buildReceiptRow(
                        'TOTAL',
                        formatRupiah(widget.totalPrice),
                        isBold: true,
                        fontSize: 18,
                        valueColor: accentPink, // Total pakai Pink agar mencolok
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 CATATAN
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: buttonGold.withOpacity(0.15), // Background kuning soft
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: buttonGold.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, size: 16, color: textChocolate),
                          const SizedBox(width: 8),
                          Text(
                            'Catatan Penting',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: textChocolate,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Pesanan Anda akan diproses dalam 1-2 jam kerja\n'
                        '• Kue akan dikirim dalam kondisi segar\n'
                        '• Hubungi customer service jika ada kendala',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: textChocolate.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 🔹 TOMBOL AKSI
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 5,
                    shadowColor: accentPink.withOpacity(0.4),
                  ),
                ),

                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: _printReceipt,
                  icon: Icon(Icons.print, color: textChocolate),
                  label: Text(
                    'Cetak Struk',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: textChocolate),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: textChocolate, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isBold = false,
    double fontSize = 13,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: textChocolate.withOpacity(isBold ? 1.0 : 0.7),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: valueColor ?? textChocolate,
            ),
          ),
        ),
      ],
    );
  }

  void _printReceipt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Struk telah dikirim ke printer 🖨️',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: accentPink,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}