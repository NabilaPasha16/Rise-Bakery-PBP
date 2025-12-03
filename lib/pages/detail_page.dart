import 'package:flutter/material.dart';
import '../utils/formatters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import '../model/cake.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_cubit.dart';
import 'receipt_page.dart';

class DetailPage extends StatelessWidget {
  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  static Widget _buildImage(Cake cake) {
    final img = cake.imagePath;
    if (img.isEmpty) {
      return const SizedBox(
        width: 220,
        height: 220,
        child: Icon(Icons.image_not_supported, color: Colors.pinkAccent, size: 64),
      );
    }
    final isNetwork = img.startsWith('http://') || img.startsWith('https://');
    return SizedBox(
      width: double.infinity, // Full width agar responsif di dalam card
      height: 250,
      child: isNetwork
          ? Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 64))
          : Image.asset(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 64)),
    );
  }

  final Cake cake;
  const DetailPage({super.key, required this.cake});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparan agar terlihat elegan
        elevation: 0,
        iconTheme: IconThemeData(color: textChocolate), // Icon back warna coklat
        centerTitle: true,
        title: Text(
          "Detail Menu", // Judul generik atau cake.name
          style: GoogleFonts.poppins(
            color: textChocolate, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Stack(
        children: [
          // 1. Background Gradient Theme
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgCream, bgPeach],
              ),
            ),
          ),

          // 2. Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card Putih Pembungkus Konten
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: textChocolate.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gambar dengan Rounded Corners di atas
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                          child: _buildImage(cake),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Kategori (Badge Kecil)
                              if (cake.category != null)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: bgCream,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: buttonGold.withOpacity(0.5)),
                                  ),
                                  child: Text(
                                    cake.category!.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12, 
                                      color: textChocolate
                                    ),
                                  ),
                                ),

                              // Nama Kue
                              Text(
                                cake.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold,
                                  color: textChocolate,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Deskripsi
                              Text(
                                cake.description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: textChocolate.withOpacity(0.7),
                                  height: 1.5,
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Harga (Highlight Pink)
                              Text(
                                formatRupiah(cake.price),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: accentPink,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Rating Stars
                              AnimatedRatingStars(
                                initialRating: 3.5,
                                minRating: 0.0,
                                maxRating: 5.0,
                                filledColor: buttonGold, // Warna Emas
                                emptyColor: Colors.grey.shade300,
                                filledIcon: Icons.star,
                                halfFilledIcon: Icons.star_half,
                                emptyIcon: Icons.star_border,
                                onChanged: (double rating) {},
                                displayRatingValue: true,
                                interactiveTooltips: true,
                                customFilledIcon: Icons.star,
                                customHalfFilledIcon: Icons.star_half,
                                customEmptyIcon: Icons.star_border,
                                starSize: 30.0,
                                animationDuration: const Duration(milliseconds: 300),
                                animationCurve: Curves.easeInOut,
                                readOnly: false,
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Fitur Spesial
                              if (cake is SpecialCake)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.orange.shade200),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified, color: Colors.orange, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Fitur Spesial: ${(cake as SpecialCake).specialFeature}",
                                        style: GoogleFonts.poppins(color: Colors.orange.shade800, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Navigation Bar (Tombol)
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          minimum: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPink, // Warna Pink Tema
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 5,
                    shadowColor: accentPink.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    // Direct buy: show confirmation and perform purchase immediately
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Konfirmasi Pembelian', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        content: Text('Total: ${formatRupiah(cake.price)}. Lanjutkan pembayaran?', style: GoogleFonts.poppins()),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Bayar')),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      if (!context.mounted) return;
                      // Navigasi ke halaman struk pembayaran
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReceiptPage(
                            items: [cake],
                            totalPrice: cake.price,
                            paymentMethod: 'Transfer Bank',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Beli Sekarang",
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentPink,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: accentPink.withOpacity(0.5), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    // Add to shared cart via CartCubit
                    context.read<CartCubit>().add(cake);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${cake.name} ditambahkan ke keranjang', style: GoogleFonts.poppins()),
                        backgroundColor: textChocolate,
                        duration: const Duration(milliseconds: 1500),
                      )
                    );
                  },
                  child: Text('Masukan keranjang', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}