import 'package:flutter/material.dart';
import '../utils/formatters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import '../model/cake.dart';
import '../utils/cart_manager.dart';

class DetailPage extends StatelessWidget {
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
      width: 220,
      height: 220,
      child: isNetwork
          ? Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 64))
          : Image.asset(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 64)),
    );
  }
  final Cake cake;
  const DetailPage({super.key, required this.cake});

  @override
  Widget build(BuildContext context) {
  // use shared formatter util
  // final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        title: Text(cake.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildImage(cake),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              cake.name,
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              cake.description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            if (cake.category != null)
              Text(
                "Kategori: ${cake.category!.name}",
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 8),
            Text(
              "Harga: ${formatRupiah(cake.price)}",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            AnimatedRatingStars(
              initialRating: 3.5,
              minRating: 0.0,
              maxRating: 5.0,
              filledColor: Colors.amber,
              emptyColor: Colors.grey,
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
            if (cake is SpecialCake)
              Text(
                "Fitur Spesial: ${(cake as SpecialCake).specialFeature}",
                style: GoogleFonts.poppins(color: Colors.orange),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  // Direct buy: show confirmation and perform purchase immediately
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Konfirmasi Pembelian'),
                      content: Text('Total: ${formatRupiah(cake.price)}. Lanjutkan pembayaran?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Bayar')),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembelian berhasil! Terima kasih.')));
                    Navigator.pop(context); // go back after purchase
                  }
                },
                child: const Text(
                  "Beli",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.pink.shade700,
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.pink.shade200),
                ),
                onPressed: () {
                  // Add to shared cart instead of navigating immediately
                  CartManager().add(cake);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${cake.name} ditambahkan ke keranjang')));
                },
                child: const Text('Masukan keranjang', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }
