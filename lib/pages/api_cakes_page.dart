import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // Pastikan import ini ada
import '../services/api_service.dart';
import '../bloc/cakes_cubit.dart';
import '../bloc/cakes_state.dart';
import '../model/cake.dart';
import '../utils/formatters.dart';
import 'detail_page.dart';
import 'cart_page.dart';

class ApiCakesPage extends StatelessWidget {
  final ApiService apiService;
  const ApiCakesPage({super.key, required this.apiService});

  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CakesCubit(apiService: apiService)..fetchCakes(),
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: bgCream,
        appBar: AppBar(
          backgroundColor: bgCream,
          centerTitle: true,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: textChocolate),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          title: Text(
            'DAFTAR KUE',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: textChocolate,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.shopping_cart, color: accentPink),
                  tooltip: 'Keranjang',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: textChocolate),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == 'refresh') {
                      context.read<CakesCubit>().fetchCakes();
                    }
                  },
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      value: 'refresh',
                      child: Row(
                        children: [
                          Icon(Icons.refresh, color: textChocolate, size: 20),
                          const SizedBox(width: 8),
                          Text('Refresh Data', style: GoogleFonts.poppins(color: textChocolate)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bgCream, bgPeach],
            ),
          ),
          child: const _ApiCakesView(),
        ),
      ),
    );
  }
}

class _ApiCakesView extends StatefulWidget {
  const _ApiCakesView({Key? key}) : super(key: key);

  @override
  State<_ApiCakesView> createState() => _ApiCakesViewState();
}

class _ApiCakesViewState extends State<_ApiCakesView> {
  final TextEditingController _searchCtrl = TextEditingController();

  // Warna lokal untuk state
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color bgCream = const Color(0xFFFFF3E0);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔍 Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: textChocolate.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchCtrl,
              onSubmitted: (q) => context.read<CakesCubit>().search(q),
              style: GoogleFonts.poppins(color: textChocolate),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: accentPink),
                hintText: 'Cari kue favoritmu...',
                hintStyle: GoogleFonts.poppins(color: textChocolate.withOpacity(0.5)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send_rounded, color: accentPink),
                  onPressed: () => context.read<CakesCubit>().search(_searchCtrl.text),
                ),
              ),
            ),
          ),
        ),

        // 📜 Daftar kue
        Expanded(
          child: BlocBuilder<CakesCubit, dynamic>(
            builder: (context, state) {
              if (state is CakesLoading) {
                return Center(child: CircularProgressIndicator(color: accentPink));
              }
              if (state is CakesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off_rounded, size: 48, color: textChocolate.withOpacity(0.5)),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: GoogleFonts.poppins(color: textChocolate),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => context.read<CakesCubit>().fetchCakes(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentPink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("Coba Lagi"),
                      )
                    ],
                  ),
                );
              }
              if (state is CakesLoaded) {
                final cakes = state.cakes;
                if (cakes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cookie_outlined, size: 60, color: textChocolate.withOpacity(0.3)),
                        const SizedBox(height: 12),
                        Text(
                          'Kue tidak ditemukan 🧁',
                          style: GoogleFonts.poppins(
                            color: textChocolate.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: cakes.length,
                  itemBuilder: (context, index) {
                    final Cake cake = cakes[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(cake: cake)),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: textChocolate.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildImage(cake),
                          ),
                          title: Text(
                            cake.name,
                            style: GoogleFonts.poppins(
                              color: textChocolate,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              formatRupiah(cake.price),
                              style: GoogleFonts.poppins(
                                color: accentPink,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: bgCream,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.arrow_forward_ios_rounded, 
                              color: textChocolate, size: 14),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImage(Cake cake) {
    final img = cake.imagePath;
    if (img.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey[100],
        child: Icon(Icons.image_not_supported, color: accentPink.withOpacity(0.5)),
      );
    }
    final isNetwork = img.startsWith('http://') || img.startsWith('https://');
    return SizedBox(
      width: 60,
      height: 60,
      child: isNetwork
          ? Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
          : Image.asset(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image)),
    );
  }
}