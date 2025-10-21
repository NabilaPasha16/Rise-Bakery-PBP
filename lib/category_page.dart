import 'package:flutter/material.dart';
import 'utils/formatters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/cake.dart';
import 'detail_page.dart';
import 'cart_page.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final List<Cake> cakes;

  const CategoryPage({
    super.key,
    required this.category,
    required this.cakes,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // local cart for backward compatibility
  final List<Cake> cartItems = [];

  @override
  Widget build(BuildContext context) {
  // Use shared formatter util
  // final currencyFormat = NumberFormat.currency(locale: "id_ID", symbol: "Rp ");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink.shade200,
        // no actions (cart icon removed as requested)
      ),
      body: ListView.builder(
        itemCount: widget.cakes.length,
        itemBuilder: (context, index) {
          final cake = widget.cakes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  cake.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                cake.name,
                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                formatRupiah(cake.price),
                style: GoogleFonts.montserrat(color: Colors.pink.shade700),
              ),
                  trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tombol detail
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(cake: cake),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Detail"),
                  ),
                  const SizedBox(width: 6),
                  // Tombol Beli langsung (buy-now: navigate to CartPage with single item)
                  ElevatedButton(
                    onPressed: () async {
                      // Direct buy: navigate to CartPage in buy-now mode
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CartPage(buyNowItem: cake)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Beli'),
                  ),
                  const SizedBox(width: 6),
                  // Tombol tambah ke keranjang (global)
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        color: Colors.pink.shade400,
                        tooltip: "Tambah ke Keranjang",
                        onPressed: () {
                          // Open CartPage with this single item
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage(items: [cake])));
                        },
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}