import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';
import 'model/cake.dart';
import 'model/cake_category.dart';
import 'detail_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  final String email;

  HomePage({super.key, required this.email});

  // Daftar kategori kue
  final List<CakeCategory> categories = [
    CakeCategory(
      id: "1",
      name: "BurnCheeseCake",
      description: "BurnCheeseCake Series",
      assetImage: "assets/burncheesecake_matcha.png",
    ),
    CakeCategory(
      id: "2",
      name: "Tar Cake",
      description: "Tar Cake Series",
      assetImage: "assets/tarcake_coklat.png",
    ),
    CakeCategory(
      id: "3",
      name: "MileCrepes",
      description: "MileCrepes Series",
      assetImage: "assets/milecrepes_matcha.png",
    ),
    CakeCategory(
  id: "4",
  name: "Special Cake",
  description: "Varian kue spesial premium",
  assetImage: "assets/burncheesecake_premium.png",
),

  ];

  // Daftar kue tiap kategori
  final List<Cake> burnCheeseCakeList = [
    Cake("BurnCheeseCake Matcha", 135000, "assets/burncheesecake_matcha.png",
        description:
            "Perpaduan lembutnya cheesecake dengan aroma matcha khas, manis pahitnya pas dan elegan."),
    Cake("BurnCheeseCake Brownis", 135000, "assets/burncheesecake_brownis.png",
        description:
            "Cheesecake lumer dengan topping brownies coklat fudgy, kombinasi rich & bikin nagih."),
    Cake("BurnCheeseCake Biscoff", 140000, "assets/burncheesecake_biscoff.png",
        description:
            "Cheesecake creamy dipadu biskuit karamel Biscoff, rasa manis gurih dengan wangi khas."),
    Cake("BurnCheeseCake Strawberry", 140000,
        "assets/burncheesecake_strawberry.png",
        description:
            "Cheesecake lembut dengan segarnya strawberry, manis asam yang fresh di setiap gigitan."),
  ];

  final List<Cake> tarCakeList = [
    Cake("Tar Cake Coklat", 120000, "assets/tarcake_coklat.png",
        description:
            "Cake coklat moist dengan krim coklat lumer, rasa rich & manisnya bikin nggak berhenti makan."),
    Cake("Tar Cake Matcha", 120000, "assets/tarcake_matcha.png",
        description:
            "Lembutnya sponge cake dengan krim matcha asli, rasa manis-pahit khas teh hijau yang menenangkan."),
    Cake("Tar Cake Tiramisu", 125000, "assets/tarcake_tiramisu.png",
        description:
            "Lapisan cake lembut dengan krim keju dan aroma kopi klasik, manisnya pas & elegan."),
  ];

  final List<Cake> mileCrepesList = [
    Cake("MileCrepes Matcha", 150000, "assets/milecrepes_matcha.png",
        description:
            "Crepes lembut berlapis krim matcha asli, rasa manis-pahitnya bikin nagih."),
    Cake("MileCrepes Dark Choco", 150000, "assets/milecrepes_darkchoco.png",
        description:
            "Perpaduan cokelat hitam premium dengan crepes tipis, rasa rich & elegan untuk pecinta cokelat."),
    Cake("MileCrepes Cookies & Cream", 155000,
        "assets/milecrepes_cookiescream.png",
        description:
            "Lembutnya crepes dipadukan krim manis dan cookies renyah, favorit semua kalangan."),
  ];
  
    final List<Cake> specialCakeList = [
  SpecialCake(
    "BurnCheeseCake Premium",
    200000,
    "assets/burncheesecake_premium.png",
    "Extra Topping",
    description: "Cheesecake premium dengan topping ekstra dan bahan pilihan.",
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade200, Colors.pink.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    GFAvatar(
                      radius: 42,
                      backgroundImage: AssetImage('assets/profil.png'),
                      shape: GFAvatarShape.standard,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _displayNameFromEmail(email),
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // Card yang dapat diklik untuk membuka Clairmont Cake di browser
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openClairmont(context),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.language, color: Colors.pinkAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Kunjungi Clairmont Cake',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Icon(Icons.open_in_new, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    GFListTile(
                      avatar: const Icon(Icons.notifications_none, color: Colors.pinkAccent),
                      titleText: 'Notifications',
                      subTitleText: '',
                      onTap: () {},
                    ),
                    GFListTile(
                      avatar: const Icon(Icons.chat_bubble_outline, color: Colors.pinkAccent),
                      titleText: 'Reviews',
                      onTap: () {},
                    ),
                    GFListTile(
                      avatar: const Icon(Icons.payment_outlined, color: Colors.pinkAccent),
                      titleText: 'Payments',
                      onTap: () {},
                    ),
                    GFListTile(
                      avatar: const Icon(Icons.settings_outlined, color: Colors.pinkAccent),
                      titleText: 'Settings',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: GFButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  text: 'Logout',
                  icon: const Icon(Icons.power_settings_new, color: Colors.white),
                  color: Colors.pink.shade100,
                  blockButton: true,
                ),
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        title: Center(
          child: Text(
            'PILACAKE',
            style: GoogleFonts.fredoka(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 187, 214, 1),
        elevation: 6,
        toolbarHeight: 100,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Selamat Datang
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12, top: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade200, Colors.pink.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Selamat datang, $email',
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.pink.shade700.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GFCarousel(
  autoPlay: true,
  viewportFraction: 0.9,
  height: 160,
  activeIndicator: Colors.pinkAccent,
  passiveIndicator: Colors.grey.shade400,
  autoPlayInterval: const Duration(seconds: 3),
  items: [
    // Banner 1
    Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/burncheesecake_matcha.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🎉 BurnCheeseCake Matcha",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Diskon 15% minggu ini aja 🍵",
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    // Banner 2
    Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/tarcake_coklat.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🍫 Tar Cake Coklat Lumer",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Nikmati sensasi coklat premium!",
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ),

    // Banner 3
    Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: AssetImage('assets/milecrepes_matcha.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "🍰 MileCrepes Matcha",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Beli 2 gratis 1 minggu ini 💚",
                style: GoogleFonts.montserrat(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ],
),

GFAccordion(
  title: "Tentang PILACAKE 🍰",
  content:
      "Setiap kue dibuat handmade dengan bahan segar dan cinta. Yuk, coba rasa baru tiap minggunya! 💕",
  collapsedIcon: const Icon(Icons.add_circle_outline, color: Colors.pinkAccent),
  expandedIcon: const Icon(Icons.remove_circle_outline, color: Colors.pinkAccent),
  titleBorderRadius: BorderRadius.circular(10),
  margin: const EdgeInsets.symmetric(horizontal: 16),
  textStyle: GoogleFonts.montserrat(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.pinkAccent,
  ),
)
,

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final List<Cake> cakeList;
                    if (category.name == "BurnCheeseCake") {
                      cakeList = burnCheeseCakeList;
                    } else if (category.name == "Tar Cake") {
                      cakeList = tarCakeList;

                    } else if (category.name == "MileCrepes") {
                      cakeList = mileCrepesList;
                    }
                    
                    else {
                      cakeList = specialCakeList ;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16), // kotak lebih besar
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16), // lebih lega
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(category.assetImage),
                          radius: 36, // gambar lebih besar
                        ),
                        title: Text(
                          category.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20, // font lebih besar
                            color: Colors.pink.shade700,
                          ),
                        ),
                        subtitle: Text(
                          category.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 22),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                category: category.name,
                                cakes: cakeList,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _displayNameFromEmail(String email) {
    if (email.isEmpty) return 'Guest';
    final local = email.split('@').first;
    if (local.isEmpty) return 'Guest';
    // replace dots/underscores with space and capitalize
    final parts = local.replaceAll(RegExp(r'[._]'), ' ').split(' ');
    final transformed = parts.map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}').join(' ');
    return transformed;
  }
}

// Helper to open Clairmont site in external browser
Future<void> _openClairmont(BuildContext context) async {
  final uri = Uri.parse('https://clairmontcake.co.id/');
  try {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka situs')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuka situs')));
  }
}
