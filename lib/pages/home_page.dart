import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../model/cake.dart';
import '../model/cake_category.dart';
import 'category_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import '../services/api_service.dart';
import 'api_cakes_page.dart';
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
  // Device info
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = {};
  bool _loadingDevice = true;

  // Profile header
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
    Cake(
      "BurnCheeseCake Matcha",
      135000,
      "assets/burncheesecake_matcha.png",
      description:
          "Perpaduan lembutnya cheesecake dengan aroma matcha khas, manis pahitnya pas dan elegan.",
    ),
    Cake(
      "BurnCheeseCake Brownis",
      135000,
      "assets/burncheesecake_brownis.png",
      description:
          "Cheesecake lumer dengan topping brownies coklat fudgy, kombinasi rich & bikin nagih.",
    ),
    Cake(
      "BurnCheeseCake Biscoff",
      140000,
      "assets/burncheesecake_biscoff.png",
      description:
          "Cheesecake creamy dipadu biskuit karamel Biscoff, rasa manis gurih dengan wangi khas.",
    ),
    Cake(
      "BurnCheeseCake Strawberry",
      140000,
      "assets/burncheesecake_strawberry.png",
      description:
          "Cheesecake lembut dengan segarnya strawberry, manis asam yang fresh di setiap gigitan.",
    ),
  ];

  final List<Cake> tarCakeList = [
    Cake(
      "Tar Cake Coklat",
      120000,
      "assets/tarcake_coklat.png",
      description:
          "Cake coklat moist dengan krim coklat lumer, rasa rich & manisnya bikin nggak berhenti makan.",
    ),
    Cake(
      "Tar Cake Matcha",
      120000,
      "assets/tarcake_matcha.png",
      description:
          "Lembutnya sponge cake dengan krim matcha asli, rasa manis-pahit khas teh hijau yang menenangkan.",
    ),
    Cake(
      "Tar Cake Tiramisu",
      125000,
      "assets/tarcake_tiramisu.png",
      description:
          "Lapisan cake lembut dengan krim keju dan aroma kopi klasik, manisnya pas & elegan.",
    ),
  ];

  final List<Cake> mileCrepesList = [
    Cake(
      "MileCrepes Matcha",
      150000,
      "assets/milecrepes_matcha.png",
      description:
          "Crepes lembut berlapis krim matcha asli, rasa manis-pahitnya bikin nagih.",
    ),
    Cake(
      "MileCrepes Dark Choco",
      150000,
      "assets/milecrepes_darkchoco.png",
      description:
          "Perpaduan cokelat hitam premium dengan crepes tipis, rasa rich & elegan untuk pecinta cokelat.",
    ),
    Cake(
      "MileCrepes Cookies & Cream",
      155000,
      "assets/milecrepes_cookiescream.png",
      description:
          "Lembutnya crepes dipadukan krim manis dan cookies renyah, favorit semua kalangan.",
    ),
  ];

  final List<Cake> specialCakeList = [
    Cake(
      "BurnCheeseCake Premium",
      200000,
      "assets/burncheesecake_premium.png",
      description:
          "Cheesecake premium dengan topping ekstra dan bahan pilihan.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('displayName');
      final storedAvatar = prefs.getString('avatarPath');
      setState(() {
        _displayName = storedName ?? _displayNameFromEmail(widget.email);
        _avatarPath = storedAvatar;
      });
    } catch (_) {}
  }

  Future<void> _initDeviceInfo() async {
    try {
      if (kIsWeb) {
        final info = await _deviceInfo.webBrowserInfo;
        setState(
          () => _deviceData = {
            'browser': info.browserName.toString(),
            'userAgent': info.userAgent ?? '',
            'appVersion': info.appVersion ?? '',
            'platform': info.platform ?? '',
            'vendor': info.vendor ?? '',
          },
        );
      } else if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        setState(
          () => _deviceData = {
            'brand': info.brand,
            'model': info.model,
            'device': info.device,
            'manufacturer': info.manufacturer,
            'androidVersion': info.version.release,
          },
        );
      }
      setState(() => _loadingDevice = false);
    } catch (e) {
      setState(() {
        _deviceData = {'error': 'Failed to get device info: $e'};
        _loadingDevice = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.7)),
          ),
          _buildBody(context),
        ],
      ),
    );
  }

  // 🔹 Drawer (sidebar)
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.pinkAccent),
                    title: const Text('Profil'),
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ProfilePage(email: widget.email),
                        ),
                      );
                      await _loadProfile();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud, color: Colors.pinkAccent),
                    title: const Text('Kue dari Internet 🍩'),
                    onTap: () async {
                      Navigator.pop(context);
                      final api = ApiService();
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => ApiCakesPage(apiService: api),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Informasi Device
                  if (!_loadingDevice) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Perangkat',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.pink.shade700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_deviceData.containsKey('model'))
                            Text(
                              'Model: ${_deviceData['model']}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          if (_deviceData.containsKey('brand'))
                            Text(
                              'Merek: ${_deviceData['brand']}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          if (_deviceData.containsKey('androidVersion'))
                            Text(
                              'Android: ${_deviceData['androidVersion']}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          if (_deviceData.containsKey('manufacturer'))
                            Text(
                              'Pembuat: ${_deviceData['manufacturer']}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          // Info untuk web browser
                          if (_deviceData.containsKey('browser'))
                            Text(
                              'Browser: ${_deviceData['browser']}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          if (_deviceData.containsKey('platform'))
                            Text(
                              'Platform: ${_deviceData['platform']}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: GFButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
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
    );
  }

  // 🔹 AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
      toolbarHeight: 80,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: Text(
              'KERANJANG🛒',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Body
  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
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
          ),
          child: Center(
            child: Text(
              'Selamat datang, ${widget.email}',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Tombol ke situs eksternal
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _openClairmont(context),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
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
        // 🔸 Tombol ke halaman API Cakes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.cloud, color: Colors.white),
            label: const Text(
              'Lihat Kue dari Internet 🍪',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              final api = ApiService();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ApiCakesPage(apiService: api),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final cakeList = (category.name == "BurnCheeseCake")
                  ? burnCheeseCakeList
                  : (category.name == "Tar Cake")
                  ? tarCakeList
                  : (category.name == "MileCrepes")
                  ? mileCrepesList
                  : specialCakeList;

              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 16,
                  ),
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
                        builder: (_) => CategoryPage(
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
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
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
            backgroundImage: _avatarPath != null
                ? AssetImage(_avatarPath!) as ImageProvider
                : const AssetImage('assets/profil.png'),
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
        ],
      ),
    );
  }

  String _displayNameFromEmail(String email) {
    final local = email.split('@').first;
    return local[0].toUpperCase() + local.substring(1);
  }
}

// 🔹 Buka situs Clairmont eksternal
Future<void> _openClairmont(BuildContext context) async {
  final uri = Uri.parse('https://clairmontcake.co.id/');
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Gagal membuka situs')));
  }
}
