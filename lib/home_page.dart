import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'model/cake.dart';
import 'model/cake_category.dart';
import 'category_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // device info
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = {};
  bool _loadingDevice = true;
  // profile header state (loaded from SharedPreferences)
  String? _displayName;
  String? _avatarPath;

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
  void initState() {
    super.initState();
    _initDeviceInfo();
    _loadProfile();
  }

  // Load persisted profile name/avatar from SharedPreferences (if user edited profile)
  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('displayName');
      final storedAvatar = prefs.getString('avatarPath');
      setState(() {
        if (storedName != null && storedName.isNotEmpty) {
          _displayName = storedName;
        }
        if (storedAvatar != null && storedAvatar.isNotEmpty) {
          _avatarPath = storedAvatar;
        }
      });
    } catch (_) {}
  }

  Future<void> _initDeviceInfo() async {
    try {
      if (kIsWeb) {
        final info = await _deviceInfo.webBrowserInfo;
        setState(() => _deviceData = {
              'browser': info.browserName.toString(),
              'userAgent': info.userAgent ?? '',
              'appVersion': info.appVersion ?? '',
              'platform': info.platform ?? '',
              'vendor': info.vendor ?? '',
            });
      } else if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        setState(() => _deviceData = {
              'brand': info.brand,
              'model': info.model,
              'device': info.device,
              'manufacturer': info.manufacturer,
              'androidVersion': info.version.release,
              'sdkInt': info.version.sdkInt,
              'isPhysicalDevice': info.isPhysicalDevice,
            });
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        setState(() => _deviceData = {
              'name': info.name,
              'systemName': info.systemName,
              'systemVersion': info.systemVersion,
              'model': info.model,
              'localizedModel': info.localizedModel,
              'isPhysicalDevice': info.isPhysicalDevice,
              'identifierForVendor': info.identifierForVendor,
            });
      } else {
        setState(() => _deviceData = {
              'os': Platform.operatingSystem,
              'osVersion': Platform.operatingSystemVersion,
            });
      }
      setState(() => _loadingDevice = false);
    } catch (e) {
      setState(() {
        _deviceData = {'error': 'Failed to get device info: $e'};
        _loadingDevice = false;
      });
    }
  }

  String _deviceModelDisplay() {
    final model = _deviceData['model'] ?? _deviceData['device'] ?? _deviceData['name'] ?? '';
    final brand = _deviceData['brand'] ?? _deviceData['manufacturer'] ?? '';
    final candidate = '${brand.toString()} ${model.toString()}'.trim();
    if (candidate.isEmpty) return 'Tidak diketahui';
    return model.toString().isNotEmpty ? model.toString() : candidate;
  }

  String _deviceBrandDisplay() {
    final brand = _deviceData['brand'] ?? _deviceData['manufacturer'] ?? '';
    if (brand == null || brand.toString().trim().isEmpty) return 'Tidak diketahui';
    return brand.toString();
  }

  String _deviceVersionDisplay() {
    final v = _deviceData['systemVersion'] ?? _deviceData['androidVersion'] ?? _deviceData['osVersion'] ?? _deviceData['appVersion'] ?? _deviceData['userAgent'] ?? '';
    if (v == null || v.toString().trim().isEmpty) {
      try {
        if (!kIsWeb) return Platform.operatingSystemVersion;
      } catch (_) {}
      return 'Tidak diketahui';
    }
    return v.toString();
  }

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
                      backgroundImage: _avatarPath != null && !_avatarPath!.startsWith('http')
                          ? AssetImage(_avatarPath!)
                          : (_avatarPath != null ? NetworkImage(_avatarPath!) : const AssetImage('assets/profil.png')) as ImageProvider,
                      shape: GFAvatarShape.standard,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _displayName ?? _displayNameFromEmail(widget.email),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person, color: Colors.pinkAccent),
                      title: const Text('Profil'),
                      onTap: () async {
                        Navigator.pop(context);
                        await Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProfilePage(email: widget.email)));
                        // refresh profile header after returning
                        await _loadProfile();
                      },
                    ),
                    // Settings removed per user request
                    ListTile(
                      leading: const Icon(Icons.info_outline, color: Colors.pinkAccent),
                      title: const Text('Tentang PILACAKE'),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(context: context, builder: (ctx) => AlertDialog(
                          title: const Text('Tentang PILACAKE'),
                          content: const Text('Yuk, coba rasa baru tiap minggunya! 💕'),
                          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Tutup'))],
                        ));
                      },
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text('Info Perangkat:', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.blue)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: _loadingDevice
                          ? const SizedBox(height: 48, child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator())))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Model: ${_deviceModelDisplay()}', style: GoogleFonts.poppins(fontSize: 13)),
                                const SizedBox(height: 6),
                                Text('Brand: ${_deviceBrandDisplay()}', style: GoogleFonts.poppins(fontSize: 13)),
                                const SizedBox(height: 6),
                                Text('Versi: ${_deviceVersionDisplay()}', style: GoogleFonts.poppins(fontSize: 13)),
                                const SizedBox(height: 12),
                              ],
                            ),
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
        centerTitle: true,
        title: Text(
          'PILACAKE',
          style: GoogleFonts.poppins(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(255, 187, 214, 1),
        elevation: 6,
        toolbarHeight: 80,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartPage()),
                  );
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                label: Text('KERANJANG🛒', style: GoogleFonts.poppins(color: Colors.white)),
                style: TextButton.styleFrom(foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12)),
              ),
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
              color: Colors.white.withAlpha((0.7 * 255).round()),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Selamat Datang
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12, top: 16),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink.shade200, Colors.pink.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withAlpha((0.4 * 255).round()),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Selamat datang, ${widget.email}',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.pink.shade700.withAlpha((0.3 * 255).round()),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Carousel and accordion
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    GFCarousel(
                      autoPlay: true,
                      viewportFraction: 0.9,
                      height: 160,
                      activeIndicator: Colors.pinkAccent,
                      passiveIndicator: Colors.grey.shade400,
                      autoPlayInterval: const Duration(seconds: 3),
                      items: [
                        // Banner 1
                        _buildBanner('assets/promomatcha.png', 'MILECREPES MATCHA', 'Cobain Sekarang'),
                        _buildBanner('assets/promotarcakecoklat.png', 'TAR CAKE COKLAT Lumer', 'Spesial Launching!'),
                        _buildBanner('assets/promoburncheese.png', 'BURNCHEESE CAKE MATCHA', 'SPESIAL 10.10'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // 'Tentang PILACAKE' dipindah ke Drawer
                    const SizedBox(height: 8),
                    // Card untuk membuka Clairmont Cake di browser
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
                                    'Kunjungi Situs Kue 🍰',
                                    style: GoogleFonts.poppins(
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
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Category list
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
                    } else {
                      cakeList = specialCakeList;
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(category.assetImage),
                          radius: 36,
                        ),
                        title: Text(
                          category.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                        trailing: const Icon(Icons.arrow_forward_ios, size: 22),
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

  Widget _buildBanner(String assetPath, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              assetPath,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stack) {
                // Fallback placeholder when asset missing
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade300, Colors.pink.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.local_offer, size: 64, color: Colors.white24),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha((0.5 * 255).round()),
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
                    title,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
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
