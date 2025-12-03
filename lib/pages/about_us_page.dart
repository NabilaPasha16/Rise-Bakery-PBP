import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  @override
  Widget build(BuildContext context) {
    final members = [
      {
        'name': 'Restu',
        'nim': '24111814',
        'role': 'Project Lead & UI Designer',
        'ig': '@restu.ui',
        'github': 'github.com/restuUI',
        'image': 'assets/restu.jpg',
      },
      {
        'name': 'Oktavio',
        'nim': '233307002',
        'role': 'Flutter Developer',
        'ig': '@oktavio.dev',
        'github': 'github.com/oktavioDev',
        'image': 'assets/oktavio.jpg',
      },
      {
        'name': 'Rifkia',
        'nim': '233307003',
        'role': '3D & AR Specialist',
        'ig': '@rifkia.3d',
        'github': 'github.com/rifkia3d',
        'image': 'assets/rifkia.jpg',
      },
      {
        'name': 'Rakha',
        'nim': '233307004',
        'role': 'QA & Tester',
        'ig': '@rakha.qat',
        'github': 'github.com/rakhadev',
        'image': 'assets/rakha.jpg',
      },
      {
        'name': 'Pratama',
        'nim': '233307005',
        'role': 'Content Writer',
        'ig': '@pratama.writer',
        'github': 'github.com/pratamawrite',
        'image': 'assets/diki.jpg.jpg',
      },
      {
        'name': 'Nabila',
        'nim': '233307006',
        'role': 'Asset Research',
        'ig': '@nabilapasha',
        'github': 'github.com/nabilapasha',
        'image': 'assets/nabila.jpg',
      },
      {
        'name': 'Enjel',
        'nim': '233307007',
        'role': 'UI/UX Support',
        'ig': '@enjel',
        'github': 'github.com/enjelsmart',
        'image': 'assets/enjel.jpg',
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        title: Text(
          'About Us',
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ======================= PROFILE HEADER =======================
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: textChocolate.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.bakery_dining,
                            size: 50,
                            color: accentPink, // Icon Pink
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Rise Bakery",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textChocolate,
                        ),
                      ),
                      Text(
                        "Flutter • Bakery App",
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textChocolate.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // ======================= DESCRIPTION =======================
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8), // Semi-transparan
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: textChocolate.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tentang Aplikasi',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textChocolate,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rise Bakery merupakan aplikasi mobile yang dikembangkan menggunakan Flutter '
                        'untuk membantu pelanggan menemukan roti dan kue favorit mereka dengan lebih mudah. '
                        'Aplikasi ini menyediakan fitur katalog, pencarian produk, kategori, detail bahan, harga, '
                        'dan fitur pesanan. Selain itu, Rise Bakery menghadirkan tampilan antarmuka yang bersih dan menarik '
                        'untuk memberikan pengalaman pengguna yang lebih baik.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          height: 1.6,
                          color: textChocolate.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // ======================= TEAM TITLE =======================
                Text(
                  'Tim Kami',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textChocolate,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Berikut anggota tim yang berkontribusi dalam pengembangan Rise Bakery.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: textChocolate.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                // ======================= GRID MEMBERS (3 Columns) =======================
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: members.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 KOTAK DALAM 1 BARIS
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: 0.68, // Rasio agar teks muat di bawah
                  ),
                  itemBuilder: (context, idx) {
                    final m = members[idx];
                    final name = m['name'] as String;
                    final role = m['role'] as String;
                    final nim = m['nim'] as String;
                    final ig = m['ig'] as String;
                    final github = m['github'] as String;
                    final imagePath = m['image'] as String;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                            color: textChocolate.withOpacity(0.15),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Column(
                        children: [
                          // --- BAGIAN FOTO (ASSETS) ---
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: bgPeach, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 30, // Ukuran foto
                              backgroundColor: bgCream,
                              backgroundImage: AssetImage(imagePath), // Memuat gambar
                              onBackgroundImageError: (exception, stackTrace) {
                                debugPrint("Gagal memuat gambar: $imagePath");
                              },
                              child: imagePath.isEmpty
                                  ? Icon(Icons.person, color: accentPink)
                                  : null,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // --- DATA ANGGOTA ---
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: textChocolate,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),

                          Text(
                            nim,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: textChocolate.withOpacity(0.6),
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            role,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: accentPink, // Peran warna Pink
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const Spacer(),

                          Text(
                            ig,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: textChocolate.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),

                          Text(
                            github,
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              color: Colors.blue.shade700, // Tetap biru untuk link
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}