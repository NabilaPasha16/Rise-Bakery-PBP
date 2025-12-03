import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
      backgroundColor: const Color(0xfffff0f7),
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color(0xffffb6d9),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ======================= PROFILE HEADER =======================
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.pink.shade200,
                    child: const Icon(
                      Icons.bakery_dining,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Rise Bakery",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade600,
                    ),
                  ),
                  Text(
                    "Flutter • Bakery App",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ======================= DESCRIPTION =======================
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tentang Aplikasi',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
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
                height: 1.5,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 35),

            // ======================= TEAM TITLE =======================
            Text(
              'Tim Kami',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Berikut anggota tim yang berkontribusi dalam pengembangan Rise Bakery.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade700,
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
                childAspectRatio: 0.70, // Rasio agar teks muat di bawah
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
                        blurRadius: 7,
                        offset: const Offset(2, 4),
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Column(
                    children: [
                      // --- BAGIAN FOTO (ASSETS) ---
                      CircleAvatar(
                        radius: 30, // Ukuran foto
                        backgroundColor: Colors.pink.shade100,
                        backgroundImage: AssetImage(imagePath), // Memuat gambar
                        onBackgroundImageError: (exception, stackTrace) {
                          debugPrint("Gagal memuat gambar: $imagePath");
                        },
                        child: imagePath.isEmpty
                            ? const Icon(Icons.person, color: Colors.white)
                            : null,
                      ),

                      const SizedBox(height: 8),

                      // --- DATA ANGGOTA ---
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),

                      Text(
                        nim,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        role,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.pink.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      Text(
                        ig,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.pink.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),

                      Text(
                        github,
                        style: GoogleFonts.poppins(
                          fontSize: 9,
                          color: Colors.blue.shade600,
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
    );
  }
}