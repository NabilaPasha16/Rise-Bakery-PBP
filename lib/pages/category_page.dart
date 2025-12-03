import 'package:flutter/material.dart';
import '../utils/formatters.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/cake.dart';
import 'detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_cubit.dart';

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
  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: textChocolate, // Warna teks Coklat
          ),
        ),
        backgroundColor: Colors.transparent, // Transparan
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textChocolate), // Icon back coklat
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
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10), // Tambah padding list
            itemCount: widget.cakes.length,
            itemBuilder: (context, index) {
              final cake = widget.cakes[index];
              return Card(
                color: Colors.white, // Card Putih Bersih
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4, // Shadow sedikit lebih tegas
                shadowColor: textChocolate.withOpacity(0.2), // Warna shadow coklat
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Sudut lebih bulat
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(cake: cake),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(12), // Padding dalam card lebih lega
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align top
                      children: [
                        // Gambar kue
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: 80, // Gambar sedikit diperbesar agar jelas
                            height: 80,
                            child: (cake.imagePath.startsWith('http://') || cake.imagePath.startsWith('https://'))
                                ? Image.network(cake.imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
                                : Image.asset(cake.imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image)),
                          ),
                        ),
                        const SizedBox(width: 14),

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
                                  color: textChocolate, // Warna Coklat
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatRupiah(cake.price),
                                style: GoogleFonts.poppins(
                                  color: accentPink, // Warna Pink
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tombol Aksi (Column)
                        Column(
                          children: [
                            // Tombol Beli
                            ElevatedButton(
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Konfirmasi Pembelian', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textChocolate)),
                                    content: Text('Beli ${cake.name} seharga ${formatRupiah(cake.price)}?', style: GoogleFonts.poppins(color: textChocolate)),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
                                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Bayar', style: TextStyle(color: accentPink, fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  // simulate purchase success
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pembelian ${cake.name} berhasil!', style: GoogleFonts.poppins())));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentPink, // Ganti Orange jadi Pink Tema
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                elevation: 2,
                              ),
                              child: Text(
                                'Beli',
                                style: GoogleFonts.poppins(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Tombol Keranjang
                            OutlinedButton(
                              onPressed: () {
                                context.read<CartCubit>().add(cake);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${cake.name} ditambahkan ke keranjang', style: GoogleFonts.poppins()),
                                    backgroundColor: textChocolate,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: textChocolate.withOpacity(0.5)), // Outline Coklat Soft
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                              ),
                              child: Icon(
                                Icons.shopping_cart_outlined, 
                                color: textChocolate, 
                                size: 18
                              ), 
                              // Saya ganti Text "Keranjang" jadi Icon agar lebih rapih & muat di layout
                              // Jika ingin tetap Text, bisa diganti kembali
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
        ),
      ),
    );
  }
}