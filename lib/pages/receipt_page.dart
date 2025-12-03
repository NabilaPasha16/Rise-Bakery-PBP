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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          'Struk Pembayaran 🧾',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.pink.shade400,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 HEADER TOKO
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '🍰 PILACAKE BAKERY 🍰',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toko Kue Premium Indonesia',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 INFO TRANSAKSI
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                      valueColor: Colors.green.shade600,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 DAFTAR ITEM
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
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
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'x1',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatRupiah(item.price),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.pink.shade700,
                                  ),
                                ),
                              ],
                            ),
                            if (idx < widget.items.length - 1)
                              Column(
                                children: [
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 RINGKASAN PEMBAYARAN
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildReceiptRow(
                      'Subtotal',
                      formatRupiah(widget.totalPrice),
                    ),
                    const SizedBox(height: 12),
                    _buildReceiptRow(
                      'Diskon',
                      formatRupiah(0),
                      valueColor: Colors.orange.shade600,
                    ),
                    const SizedBox(height: 12),
                    _buildReceiptRow(
                      'Ongkos Kirim',
                      'Gratis',
                      valueColor: Colors.green.shade600,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1.5,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    _buildReceiptRow(
                      'TOTAL',
                      formatRupiah(widget.totalPrice),
                      isBold: true,
                      fontSize: 16,
                      valueColor: Colors.pink.shade700,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 🔹 CATATAN
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade200,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 Catatan Penting',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Pesanan Anda akan diproses dalam 1-2 jam kerja\n'
                      '• Kue akan dikirim dalam kondisi segar\n'
                      '• Hubungi customer service jika ada kendala',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.blue.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 TOMBOL AKSI
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.home),
                label: Text(
                  'Kembali ke Beranda',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _printReceipt,
                icon: const Icon(Icons.print),
                label: Text(
                  'Cetak Struk',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              const SizedBox(height: 24),
            ],
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
            color: Colors.grey.shade700,
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
              color: valueColor ?? Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }

  void _printReceipt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Struk telah dikirim ke printer 🖨️',
        ),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
