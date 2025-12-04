import 'package:flutter/material.dart';
import 'package:flutter_application_1/router/navigation_helpers.dart';
import 'package:getwidget/getwidget.dart';
import '../model/cake.dart';
import '../model/cake_category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'category_page.dart';
import 'purchase_history_page.dart';
import '../services/api_service.dart';
import 'api_cakes_page.dart';
import 'detail_page.dart';
import '../utils/formatters.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum SortOption {
  none,
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  catBurnCheeseCake,
  catTarCake,
  catMileCrepes,
  catSpecialCake,
}

class _HomePageState extends State<HomePage> {
  // Device info
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = {};
  bool _loadingDevice = true;

  // Profile header
  String? _displayName;
  String? _avatarPath;

  // --- WARNA TEMA (Luxury Bakery) ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  // Dekorasi Bulat Background
  Widget _buildDecorationCircle(
    double size,
    Color color,
    double top,
    double left,
  ) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  // Daftar kategori kue
  final List<CakeCategory> categories = [
    CakeCategory(
      '1',
      'BurnCheeseCake',
      'BurnCheeseCake Series',
      'assets/burncheesecake_matcha.png',
    ),
    CakeCategory(
      '2',
      'Tar Cake',
      'Tar Cake Series',
      'assets/tarcake_coklat.png',
    ),
    CakeCategory(
      '3',
      'MileCrepes',
      'MileCrepes Series',
      'assets/milecrepes_matcha.png',
    ),
    CakeCategory(
      '4',
      'Special Cake',
      'Varian kue spesial premium',
      'assets/burncheesecake_premium.png',
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

  // Sorting
  SortOption _sortOption = SortOption.none;

  @override
  void initState() {
    super.initState();
    _initDeviceInfo();
    _loadProfile();
  }

  List<Cake> _allCakes() {
    return [
      ...burnCheeseCakeList,
      ...tarCakeList,
      ...mileCrepesList,
      ...specialCakeList,
    ];
  }

  List<Cake> _sortedCakes() {
    var list = List<Cake>.from(_allCakes());

    switch (_sortOption) {
      case SortOption.catBurnCheeseCake:
        list = list.where((c) => c.name.contains('BurnCheeseCake')).toList();
        break;
      case SortOption.catTarCake:
        list = list.where((c) => c.name.contains('Tar Cake')).toList();
        break;
      case SortOption.catMileCrepes:
        list = list.where((c) => c.name.contains('MileCrepes')).toList();
        break;
      case SortOption.catSpecialCake:
        list = list.where((c) => c.name.contains('Premium')).toList();
        break;
      default:
        break;
    }

    switch (_sortOption) {
      case SortOption.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      default:
        break;
    }
    return list;
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
            'platform': 'web',
            'browser': info.browserName.toString(),
            'userAgent': info.userAgent ?? '',
          },
        );
      } else {
        // Non-web: try Android first, then iOS. Avoid direct use of `Platform` to keep
        // this file web-safe (no dart:io import). DeviceInfoPlugin throws if platform
        // not available, so we probe with try/catch.
        try {
          final info = await _deviceInfo.androidInfo;
          setState(
            () => _deviceData = {
              'platform': 'android',
              'brand': info.brand,
              'model': info.model,
              'androidVersion': info.version.release,
            },
          );
        } catch (_) {
          try {
            final info = await _deviceInfo.iosInfo;
            setState(
              () => _deviceData = {
                'platform': 'ios',
                'name': info.name,
                'model': info.model,
                'systemName': info.systemName,
                'systemVersion': info.systemVersion,
              },
            );
          } catch (e) {
            setState(
              () => _deviceData = {
                'error':
                    'Unsupported platform or failed to get device info: $e',
              },
            );
          }
        }
      }
    } catch (e) {
      setState(() => _deviceData = {'error': 'Failed to get device info: $e'});
    } finally {
      setState(() => _loadingDevice = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _buildDrawer(context),
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // 1. Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [bgCream, bgPeach],
              ),
            ),
          ),
          // 2. Dekorasi Bulat
          _buildDecorationCircle(80, buttonGold, height * 0.15, width * -0.1),
          _buildDecorationCircle(40, accentPink, height * 0.2, width * 0.85),
          _buildDecorationCircle(60, textChocolate, height * 0.8, width * 0.1),
          _buildDecorationCircle(100, buttonGold, height * 0.85, width * 0.7),
          _buildDecorationCircle(30, accentPink, height * 0.5, width * 0.05),

          // 3. Content
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight + 40),
              child: _buildBody(context),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 AppBar (Builder & Bubble Button)
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,

      // Menggunakan Builder agar Drawer bisa dibuka
      leading: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: textChocolate,
              radius: 22,
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: 'Menu',
              ),
            ),
          );
        },
      ),

      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Text(
          'RISE BAKERY',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: textChocolate,
          ),
        ),
      ),

      actions: [
        // Tombol Sort (dalam lingkaran putih) — gunakan Container agar ikon tampil konsisten
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: PopupMenuButton<SortOption>(
              icon: Image.asset(
                'assets/sort-icon.png',
                width: 22,
                height: 22,
                errorBuilder: (ctx, err, stack) =>
                    Icon(Icons.sort, color: textChocolate, size: 22),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (opt) => setState(() => _sortOption = opt),
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: SortOption.none,
                  child: Text(
                    'Default',
                    style: TextStyle(color: textChocolate),
                  ),
                ),
                PopupMenuItem(
                  value: SortOption.priceAsc,
                  child: Text(
                    'Harga Termurah',
                    style: TextStyle(color: textChocolate),
                  ),
                ),
                PopupMenuItem(
                  value: SortOption.priceDesc,
                  child: Text(
                    'Harga Tertinggi',
                    style: TextStyle(color: textChocolate),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: SortOption.catBurnCheeseCake,
                  child: Text(
                    'CheeseCake',
                    style: TextStyle(color: textChocolate),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tombol Keranjang (lingkaran coklat dengan ikon putih)
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16.0),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: textChocolate,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartPage()),
                );
              },
              icon: Image.asset(
                'assets/keranjang-icon.png',
                width: 22,
                height: 22,
                color: Colors.white,
                errorBuilder: (ctx, err, stack) =>
                    Icon(Icons.shopping_cart, color: Colors.white, size: 22),
              ),
              tooltip: 'Keranjang',
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Drawer (Logout Diperbaiki - Anti Crash)
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.person, color: accentPink),
                    title: Text(
                      'Profil',
                      style: GoogleFonts.poppins(color: textChocolate),
                    ),
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
                    leading: Icon(Icons.cloud, color: accentPink),
                    title: Text(
                      'Kue dari Internet 🍩',
                      style: GoogleFonts.poppins(color: textChocolate),
                    ),
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
                  ListTile(
                    leading: Icon(Icons.info, color: accentPink),
                    title: Text(
                      'About Us',
                      style: GoogleFonts.poppins(color: textChocolate),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      context.toAbout();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.history, color: accentPink),
                    title: Text(
                      'Riwayat Pembelian',
                      style: GoogleFonts.poppins(color: textChocolate),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PurchaseHistoryPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Info Device
                  if (!_loadingDevice) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bgCream,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: buttonGold.withOpacity(0.5)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Informasi Perangkat',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: textChocolate,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Tampilkan apapun yang tersedia di _deviceData secara aman
                          if (_deviceData.isNotEmpty &&
                              !_deviceData.containsKey('error')) ...[
                            if (_deviceData.containsKey('platform'))
                              Text(
                                'Platform: ${_deviceData['platform']}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                            if (_deviceData.containsKey('browser'))
                              Text(
                                'Browser: ${_deviceData['browser']}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                            if (_deviceData.containsKey('userAgent'))
                              Text(
                                'User Agent: ${_deviceData['userAgent']}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                            if (_deviceData.containsKey('brand'))
                              Text(
                                'Brand: ${_deviceData['brand']}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                            if (_deviceData.containsKey('name'))
                              Text(
                                'Name: ${_deviceData['name']}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                            if (_deviceData.containsKey('model'))
                              Text(
                                'Model: ${_deviceData['model']}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                            if (_deviceData.containsKey('androidVersion'))
                              Text(
                                'Android: ${_deviceData['androidVersion']}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                            if (_deviceData.containsKey('systemName'))
                              Text(
                                'OS: ${_deviceData['systemName']} ${_deviceData['systemVersion'] ?? ''}',
                                style: TextStyle(
                                  color: textChocolate,
                                  fontSize: 12,
                                ),
                              ),
                          ] else if (_deviceData.containsKey('error')) ...[
                            Text(
                              '${_deviceData['error']}',
                              style: TextStyle(
                                color: textChocolate,
                                fontSize: 12,
                              ),
                            ),
                          ] else ...[
                            Text(
                              'Informasi perangkat tidak tersedia',
                              style: TextStyle(
                                color: textChocolate,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ],
              ),
            ),
          ),

          // 🔴 LOGOUT FIXED (Menggunakan Future.delayed)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: GFButton(
              onPressed: () {
                // PERBAIKAN: Gunakan Future.delayed(Duration.zero)
                // untuk menunggu frame saat ini selesai sebelum melakukan navigasi.
                // Ini mencegah error "!debugLocked" (layar merah).
                Future.delayed(Duration.zero, () {
                  if (context.mounted) {
                    // Hapus semua halaman sebelumnya dan ganti dengan LoginPage
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                });
              },
              text: 'Logout',
              icon: const Icon(Icons.power_settings_new, color: Colors.white),
              color: accentPink,
              shape: GFButtonShape.pills,
              blockButton: true,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Body Content
  Widget _buildBody(BuildContext context) {
    final cakes = _sortedCakes();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Welcome
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    textChocolate.withOpacity(0.9),
                    textChocolate.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: textChocolate.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: GoogleFonts.greatVibes(
                            fontSize: 24,
                            color: buttonGold,
                          ),
                        ),
                        Text(
                          widget.email.split('@').first,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.cake_rounded, color: buttonGold, size: 40),
                ],
              ),
            ),
          ),

          // Tombol External
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openClairmont(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8D6E63).withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public, color: accentPink),
                    const SizedBox(width: 8),
                    Text(
                      'Kunjungi Situs Kue 🍰',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textChocolate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 🔸 Tombol API
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () {
                final api = ApiService();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ApiCakesPage(apiService: api),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: buttonGold,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: buttonGold.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'See more cake (API)',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textChocolate,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Explore Top Categories',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textChocolate,
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, idx) {
                final cat = categories[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      final cakeList = _allCakes()
                          .where(
                            (c) => c.name.contains(cat.name.split(' ').first),
                          )
                          .toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CategoryPage(category: cat.name, cakes: cakeList),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: DecorationImage(
                              image: AssetImage(cat.assetImage),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8D6E63).withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 82,
                          child: Text(
                            cat.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: textChocolate,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Popular
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Popular right now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textChocolate,
              ),
            ),
          ),
          SizedBox(
            height: 230,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              scrollDirection: Axis.horizontal,
              itemCount: cakes.length,
              itemBuilder: (context, idx) {
                final cake = cakes[idx];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DetailPage(cake: cake)),
                    ),
                    child: Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8D6E63).withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.asset(
                                cake.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cake.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: textChocolate,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  formatRupiah(cake.price),
                                  style: GoogleFonts.poppins(
                                    color: accentPink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgCream, bgPeach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: GFAvatar(
                radius: 42,
                backgroundImage: _avatarPath != null
                    ? AssetImage(_avatarPath!) as ImageProvider
                    : const AssetImage('assets/profil.png'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _displayName ?? _displayNameFromEmail(widget.email),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textChocolate,
              ),
            ),
            Text(
              widget.email,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: textChocolate.withOpacity(0.7),
              ),
            ),
          ],
        ),
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Gagal membuka situs')));
  }
}
