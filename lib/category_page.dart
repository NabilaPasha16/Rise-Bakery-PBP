import 'package:flutter/material.dart';
import 'utils/formatters.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/cake.dart';
import 'detail_page.dart';
import 'utils/cart_manager.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink.shade200,
      ),
      body: ListView.builder(
        itemCount: widget.cakes.length,
        itemBuilder: (context, index) {
          final cake = widget.cakes[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            child: InkWell(
              // klik seluruh card -> buka halaman detail
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(cake: cake),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    // Gambar kue
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        cake.imagePath,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Nama + harga
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cake.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatRupiah(cake.price),
                            style: GoogleFonts.poppins(
                              color: Colors.pink.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tombol Beli & Keranjang sejajar
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Konfirmasi Pembelian'),
                                content: Text('Beli ${cake.name} seharga ${formatRupiah(cake.price)}?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Bayar')),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              // simulate purchase success
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pembelian ${cake.name} berhasil!')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                          ),
                          child: const Text(
                            'Beli',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        const SizedBox(height: 6),
                        OutlinedButton(
                          onPressed: () {
                            CartManager().add(cake);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${cake.name} ditambahkan ke keranjang'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.pink.shade400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                          ),
                          child: Text(
                            'Keranjang',
                            style: TextStyle(
                              color: Colors.pink.shade400,
                              fontSize: 13,
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
        },
      ),
    );
  }
}
