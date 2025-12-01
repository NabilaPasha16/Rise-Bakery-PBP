import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../model/cake.dart';
import '../model/cake_category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';
import 'category_page.dart';
import '../services/api_service.dart';
import 'api_cakes_page.dart';
import 'detail_page.dart';
import '../utils/formatters.dart';
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

    // Filter berdasarkan kategori jika dipilih
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

    // Sort berdasarkan pilihan
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
      case SortOption.catBurnCheeseCake:
      case SortOption.catTarCake:
      case SortOption.catMileCrepes:
      case SortOption.catSpecialCake:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.none:
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
        PopupMenuButton<SortOption>(
          icon: const Icon(Icons.sort, color: Colors.white),
          onSelected: (opt) => setState(() => _sortOption = opt),
          itemBuilder: (ctx) => [
            const PopupMenuItem(value: SortOption.none, child: Text('Default')),
            const PopupMenuItem(
              value: SortOption.nameAsc,
              child: Text('Nama A-Z'),
            ),
            const PopupMenuItem(
              value: SortOption.nameDesc,
              child: Text('Nama Z-A'),
            ),
            const PopupMenuItem(
              value: SortOption.priceAsc,
              child: Text('Harga Termurah'),
            ),
            const PopupMenuItem(
              value: SortOption.priceDesc,
              child: Text('Harga Tertinggi'),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: SortOption.catBurnCheeseCake,
              child: Text('CheeseCake'),
            ),
            const PopupMenuItem(
              value: SortOption.catTarCake,
              child: Text('Tar Cake'),
            ),
            const PopupMenuItem(
              value: SortOption.catMileCrepes,
              child: Text('Crepes'),
            ),
            const PopupMenuItem(
              value: SortOption.catSpecialCake,
              child: Text('Special Cake'),
            ),
          ],
        ),
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
            label: Text('🛒', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // 🔹 Body
  Widget _buildBody(BuildContext context) {
    final cakes = _sortedCakes();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header greeting
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink.shade200, Colors.pink.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  'Selamat datang, ${widget.email}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Tombol ke situs eksternal (kembalikan)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _openClairmont(context),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 16,
                  ),
                  child: Center(
                    child: Text(
                      'Kunjungi Situs Kue 🍰',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🔸 Tombol ke halaman API Cakes (kembalikan)
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
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
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
                      color: Colors.pink.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),



          // Categories section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Explore Top Categories',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
                            image: DecorationImage(
                              image: AssetImage(cat.assetImage),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
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
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Popular right now
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Popular right now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
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
                              child:
                                  (cake.imagePath.startsWith('http://') ||
                                      cake.imagePath.startsWith('https://'))
                                  ? Image.network(
                                      cake.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                    )
                                  : Image.asset(
                                      cake.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cake.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  formatRupiah(cake.price),
                                  style: GoogleFonts.poppins(
                                    color: Colors.pink.shade700,
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
