import 'package:flutter/material.dart';
import 'utils/formatters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_rating_stars/animated_rating_stars.dart';

import 'model/cake.dart';
import 'cart_page.dart';

class DetailPage extends StatelessWidget {
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
                child: Image.asset(
                  cake.imagePath,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              cake.name,
              style: GoogleFonts.montserrat(fontSize: 24, fontWeight: FontWeight.bold),
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
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
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
                style: GoogleFonts.montserrat(color: Colors.orange),
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
                onPressed: () {
                  // Direct buy: open CartPage in buy-now mode
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage(buyNowItem: cake)),
                  );
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
                  // Open the CartPage with this single item
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(items: [cake])));
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
