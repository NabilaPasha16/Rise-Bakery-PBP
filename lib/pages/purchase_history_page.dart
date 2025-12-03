import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/purchase_history.dart';
import '../services/purchase_history_service.dart';
import '../utils/formatters.dart';

class PurchaseHistoryPage extends StatefulWidget {
  const PurchaseHistoryPage({super.key});

  @override
  State<PurchaseHistoryPage> createState() => _PurchaseHistoryPageState();
}

class _PurchaseHistoryPageState extends State<PurchaseHistoryPage> {
  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  late Future<List<PurchaseHistory>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = PurchaseHistoryService.getPurchaseHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        title: Text(
          'Riwayat Pembelian 📜',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: textChocolate, // Sesuaikan warna teks
          ),
        ),
        backgroundColor: Colors.transparent, // Transparan
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: textChocolate), // Icon back coklat
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: textChocolate),
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (value) async {
              if (value == 'clear') {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Hapus Semua Riwayat?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textChocolate)),
                    content: Text('Semua data riwayat pembelian akan dihapus. Lanjutkan?', style: GoogleFonts.poppins(color: textChocolate)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text('Batal', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text('Hapus Semua', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
                if (confirm == true && mounted) {
                  await PurchaseHistoryService.clearAllHistory();
                  _loadHistory();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Riwayat pembelian telah dihapus', style: GoogleFonts.poppins()),
                      backgroundColor: accentPink,
                    ),
                  );
                }
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'clear',
                child: Text('Hapus Semua Riwayat', style: GoogleFonts.poppins(color: textChocolate)),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        // BACKGROUND GRADIENT TEMA
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgCream, bgPeach],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<PurchaseHistory>>(
            future: _historyFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: accentPink,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: textChocolate.withOpacity(0.5)),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi kesalahan',
                        style: GoogleFonts.poppins(fontSize: 16, color: textChocolate),
                      ),
                    ],
                  ),
                );
              }

              final history = snapshot.data ?? [];

              if (history.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history_edu, // Ganti icon biar variatif
                          size: 80, color: textChocolate.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada riwayat pembelian',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textChocolate.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Mulai belanja sekarang!',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textChocolate.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final purchase = history[index];
                  return _buildHistoryCard(context, purchase);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    PurchaseHistory purchase,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shadowColor: textChocolate.withOpacity(0.15),
      color: Colors.white, // Card Putih
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showPurchaseDetail(context, purchase),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan No Transaksi dan Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          purchase.transactionId,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: accentPink, // Warna Pink Tema
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(purchase.purchaseDate),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: textChocolate.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      purchase.status,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(color: bgPeach, thickness: 1), // Divider Peach
              const SizedBox(height: 12),

              // Daftar item yang dibeli
              Text(
                'Item Pembelian (${purchase.items.length})',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textChocolate,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(
                purchase.items.length,
                (idx) {
                  final item = purchase.items[idx];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.poppins(fontSize: 12, color: textChocolate.withOpacity(0.8)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatRupiah(item.price),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textChocolate,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),
              Divider(color: bgPeach, thickness: 1),
              const SizedBox(height: 12),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pembelian',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: textChocolate,
                    ),
                  ),
                  Text(
                    formatRupiah(purchase.totalPrice),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: accentPink, // Highlight Harga
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tombol aksi
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showPurchaseDetail(context, purchase),
                      icon: Icon(Icons.visibility, size: 18, color: textChocolate),
                      label: Text(
                        'Lihat Detail',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textChocolate,
                        side: BorderSide(color: textChocolate.withOpacity(0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _deletePurchase(context, purchase),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(
                        'Hapus',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPurchaseDetail(
    BuildContext context,
    PurchaseHistory purchase,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Detail Pembelian',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textChocolate,
                ),
              ),
              const SizedBox(height: 20),
              _detailRow('No. Transaksi', purchase.transactionId),
              _detailRow('Tanggal', _formatDate(purchase.purchaseDate)),
              _detailRow('Metode Pembayaran', purchase.paymentMethod),
              _detailRow('Status', purchase.status),
              const SizedBox(height: 16),
              Divider(color: bgPeach),
              const SizedBox(height: 16),
              Text(
                'Item yang Dibeli',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textChocolate,
                ),
              ),
              const SizedBox(height: 12),
              ...purchase.items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: GoogleFonts.poppins(fontSize: 13, color: textChocolate.withOpacity(0.8)),
                          ),
                        ),
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
                  )),
              const SizedBox(height: 16),
              Divider(color: bgPeach),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textChocolate,
                    ),
                  ),
                  Text(
                    formatRupiah(purchase.totalPrice),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accentPink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: textChocolate.withOpacity(0.6),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textChocolate,
            ),
          ),
        ],
      ),
    );
  }

  void _deletePurchase(BuildContext context, PurchaseHistory purchase) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus Riwayat?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textChocolate)),
        content: Text('Data riwayat pembelian ini akan dihapus. Lanjutkan?', style: GoogleFonts.poppins(color: textChocolate)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Hapus', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await PurchaseHistoryService.deletePurchase(purchase.transactionId);
      _loadHistory();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Riwayat pembelian telah dihapus', style: GoogleFonts.poppins()),
          backgroundColor: accentPink,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year} • ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}