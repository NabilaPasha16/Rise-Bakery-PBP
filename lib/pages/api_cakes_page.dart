import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../bloc/cakes_cubit.dart';
import '../bloc/cakes_state.dart';
import '../model/cake.dart';
import '../utils/formatters.dart';
import 'detail_page.dart';

class ApiCakesPage extends StatelessWidget {
  final ApiService apiService;
  const ApiCakesPage({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CakesCubit(apiService: apiService)..fetchCakes(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFDF4F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFB6C1),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            '🍰 Daftar Kue API',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        body: const _ApiCakesView(),
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
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextField(
              controller: _searchCtrl,
              onSubmitted: (q) => context.read<CakesCubit>().search(q),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.pinkAccent),
                hintText: 'Cari kue favoritmu...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
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
                return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
              }
              if (state is CakesError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.redAccent, fontFamily: 'Poppins'),
                  ),
                );
              }
              if (state is CakesLoaded) {
                final cakes = state.cakes;
                if (cakes.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data kue 🧁', style: TextStyle(fontFamily: 'Poppins')),
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
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: _buildImage(cake),
                          ),
                          title: Text(
                            cake.name,
                            style: const TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          subtitle: Text(
                            formatRupiah(cake.price),
                            style: const TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.pinkAccent, size: 16),
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
      return const SizedBox(
        width: 56,
        height: 56,
        child: Icon(Icons.image_not_supported, color: Colors.pinkAccent),
      );
    }
    final isNetwork = img.startsWith('http://') || img.startsWith('https://');
    return SizedBox(
      width: 56,
      height: 56,
      child: isNetwork
          ? Image.network(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image))
          : Image.asset(img, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image)),
    );
  }
}
