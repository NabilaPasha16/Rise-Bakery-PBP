import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'model/cake.dart';
import 'utils/formatters.dart';

class CartPage extends StatefulWidget {
  /// If [buyNowItem] is provided, CartPage will show a single-item checkout
  /// flow that does not modify the global cart. If null, it shows the
  /// normal cart view backed by [CartManager].
  const CartPage({super.key, this.items, this.buyNowItem});

  final List<Cake>? items;
  final Cake? buyNowItem;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Cake> _items;

  double get totalPrice => widget.buyNowItem != null ? widget.buyNowItem!.price : _items.fold(0.0, (sum, item) => sum + item.price);

  @override
  void initState() {
    super.initState();
    _items = widget.items != null ? List<Cake>.from(widget.items!) : <Cake>[];
  }

  @override
  Widget build(BuildContext context) {
    final isBuyNow = widget.buyNowItem != null;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text(
          'Keranjang Belanja \ud83d\uded2',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink.shade300,
        actions: [
          if (!isBuyNow && _items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: "Kosongkan Keranjang",
              onPressed: () {
                setState(() {
                  _items.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Keranjang dikosongkan."),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
  body: isBuyNow ? _buildBuyNowBody(widget.buyNowItem!) : _buildCartBody(),
      bottomNavigationBar: _buildBottomBar(isBuyNow),
    );
  }

  Widget _buildBuyNowBody(Cake item) {
  // final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return ListView(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatRupiah(item.price), style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: Colors.pink.shade800)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Text('x1', style: GoogleFonts.montserrat()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

Widget _buildCartBody() {
  // Use local _items list for the cart page (no CartManager dependency)
  if (_items.isEmpty) {
    return Center(
      child: Text(
        "Keranjang kamu masih kosong 🍰",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  // final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
  final double totalHarga = _items.fold(0.0, (sum, it) => sum + it.price);

  return Column(
    children: [
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagePath,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(formatRupiah(item.price)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // show quantity as 1 (single-pass add). To support qty, change model.
                    Text('x1', style: const TextStyle(fontSize: 14)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.pink),
                      onPressed: () {
                        setState(() {
                          _items.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} dihapus')));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(formatRupiah(totalHarga), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.pink)),
          ],
        ),
      ),
    ],
  );
}


  Widget _buildBottomBar(bool isBuyNow) {
  // final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    if (isBuyNow) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.pink.shade400, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total:", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(formatRupiah(totalPrice), style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Konfirmasi Pembelian'),
                    content: Text('Total: ${formatRupiah(totalPrice)}. Lanjutkan pembayaran?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Bayar')),
                    ],
                  ),
                );
                if (confirm == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembelian berhasil! Terima kasih.')));
                  Navigator.pop(context); // go back after buy-now
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
              child: Text('Beli Sekarang', style: GoogleFonts.montserrat(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    // Bottom bar now reads from local _items
    if (_items.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.pink.shade400, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total:", style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
              Text(formatRupiah(totalPrice), style: GoogleFonts.montserrat(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Pembelian'),
                  content: Text('Total: ${formatRupiah(totalPrice)}. Lanjutkan pembayaran?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Bayar')),
                  ],
                ),
              );
              if (confirm == true) {
                setState(() {
                  _items.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pembelian berhasil! Terima kasih.')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
            child: Text('Beli Sekarang', style: GoogleFonts.montserrat(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
